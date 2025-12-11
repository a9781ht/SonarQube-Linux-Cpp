#!/bin/bash

# const define
MAKE_SUCCESS=0
BUILD_LOG_FOLDER="./BuildLog_Linux"
BUILD_RESULT_FOLDER="./error"
BUILD_RESULT_FILE_PATH="${BUILD_RESULT_FOLDER}/check_linux.log"

# ----- Page Function -----

# prepare build
function Page::PrepareBuild() {
  # make build log folder
  if [ ! -d "${BUILD_LOG_FOLDER}" ]; then
    mkdir -p ${BUILD_LOG_FOLDER};
  else
    # remove build log
    rm -rf ${BUILD_LOG_FOLDER:?}/*;
  fi

  # make build result folder
  if [ ! -d "${BUILD_RESULT_FOLDER}" ]; then
    mkdir -p ${BUILD_RESULT_FOLDER};
  fi

  # create empty build result file
  echo -n "" > ${BUILD_RESULT_FILE_PATH}
}

# make all
function Page::MakeAll() {
  local Platform_in=$1      # [in] platform
  local ConfigMode_in=$2    # [in] config mode

  # show performing information
  echo "----------------"
  echo "Start build:"
  echo "  Platform: ${Platform_in}"
  echo "  Config mode: ${ConfigMode_in}"

  # start compile program
  make "-j$(nproc)" "Action=Rebuild" "TargetPlatform=${Platform_in}" "ConfigMode=${ConfigMode_in}" >> ${BUILD_RESULT_FILE_PATH} 2>&1;
  MakeResult=$?

  # check make result and print information
  if [ $MakeResult -eq $MAKE_SUCCESS ]; then
    echo -e "\033[1;42;37m[Build Success]\033[0m"
  else
    # record build information in build result file
    echo "Platform: ${Platform_in}" >> ${BUILD_RESULT_FILE_PATH}
    echo "Config mode: ${ConfigMode_in}" >> ${BUILD_RESULT_FILE_PATH}

    # show error message
    echo -e "\033[1;41;37m[Build Fail!!!]\033[0m"
    echo "Please check the build log in ${BUILD_LOG_FOLDER}"

    # show build result file content
    cat ${BUILD_RESULT_FILE_PATH};
  fi

  return $MakeResult
}

# main precess state machine
function Main() {
  local Platform_in=$1      # [in] platform
  local ConfigMode_in=$2    # [in] config mode

  # state machine variable
  local RUNNING=true
  local PAGE="PrepareBuild"

  # operation local variable
  local MakeResult=""
  local ConfigModeList=""

  # run state machine
  while $RUNNING; do
    case $PAGE in

    PrepareBuild)
      Page::PrepareBuild

      # if not argument, build all config
      if [ -z "$Platform_in" ] && [ -z "$ConfigMode_in" ]; then
        PAGE="Linux_x64_Debug"
      else
        PAGE="Custom_Build"
      fi
      ;;

    # Linux_x64 Debug
    Linux_x64_Debug)
      Page::MakeAll "Linux_x64" "Debug"
      MakeResult=$?

      if [ $MakeResult -eq $MAKE_SUCCESS ]; then
        PAGE="Linux_x64_Release"
      else
        PAGE=Exit
      fi
      ;;

    # Linux_x64 Release
    Linux_x64_Release)
      Page::MakeAll "Linux_x64" "Release"
      MakeResult=$?

      if [ $MakeResult -eq $MAKE_SUCCESS ]; then
        PAGE=Exit
      else
        PAGE=Exit
      fi
      ;;

    Custom_Build)
      # if no 2nd argument, build all ConfigMode
      if [ -z "$ConfigMode_in" ]; then
        ConfigModeList="Debug Release"
      else
        ConfigModeList="$ConfigMode_in"
      fi

      for Mode in $ConfigModeList; do
        Page::MakeAll "$Platform_in" "$Mode"
        MakeResult=$?
        if [ $MakeResult -eq $MAKE_SUCCESS ]; then
            continue
        else
            break
        fi
      done
      PAGE=Exit
      ;;

    # exit state machine
    Exit)
      RUNNING=false
      ;;
    esac
  done
  if [ $MakeResult -ne $MAKE_SUCCESS ]; then
    exit 1
  fi
}

# ===== start running =====

# clear screen
clear

# run main build process
Main "$1" "$2"
