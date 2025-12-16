#!/bin/bash
 
Version="你的軟體版本"
ScannerVersion="6.1.0.4477"
 
# download build-wrapper and scanner
echo
echo '-download build-wrapper'
curl -SL --output $HOME/build-wrapper-linux-x86.zip $SONAR_HOST_URL/static/cpp/build-wrapper-linux-x86.zip
echo '-download scanner'
curl -SL --output $HOME/sonar-scanner-cli-$ScannerVersion-linux-x64.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$ScannerVersion-linux-x64.zip
 
# extract zip
echo
echo '-extract build-wrapper'
unzip $HOME/build-wrapper-linux-x86.zip -d $HOME/
echo '-extract scanner'
unzip $HOME/sonar-scanner-cli-$ScannerVersion-linux-x64.zip -d $HOME/
 
# add to PATH
echo
echo '-add build-wrapper file path into environment variable'
export PATH=$PATH:$HOME/build-wrapper-linux-x86
echo '-add scanner file path into environment variable'
export PATH=$PATH:$HOME/sonar-scanner-$ScannerVersion-linux-x64/bin
 
# define New Code
if [[ $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH ]]|| [[ $CI_COMMIT_BRANCH =~ ^你的release分支前綴_ ]]; then
  # master/main branch or release beanch
  newcode='"sonar.projectVersion='$Version'"';
else
  # feature beanch
  newcode='"sonar.newCode.referenceBranch='$NewCodeRefBranch'"';
fi
 
# start to build
echo
echo '==== SonarQube build ===='
build-wrapper-linux-x86-64 --out-dir ./SonarQube ./build.sh Linux_x64
 
# start to scan
echo
echo '==== SonarQube scan ===='
pushd ..
sonar-scanner -D"sonar.cfamily.compile-commands=Build/SonarQube/compile_commands.json" -D"sonar.projectKey=$SONARQUBE_PROJECT_KEY" -D"sonar.host.url=$SONAR_HOST_URL" -D"sonar.token=$SONAR_TOKEN" -D$newcode
if [ $? != 0 ]; then exit 1; fi
popd
 
# clean up
echo
echo '-clean up'
rm -f $HOME/build-wrapper-linux-x86.zip
rm -f $HOME/sonar-scanner-cli-$ScannerVersion-linux-x64.zip
rm -rf $HOME/build-wrapper-linux-x86
rm -rf $HOME/sonar-scanner-$ScannerVersion-linux-x64

# check upload status (avoid scanning quality gate successfully but upload to server failed)
echo
echo '-check upload status'
TASK_URL=$(grep ceTaskUrl ../.scannerwork/report-task.txt | awk -F 'ceTaskUrl=' '{print $2}')
STATUS=$(curl -u $SONAR_TOKEN: ${TASK_URL} 2>&1 | grep -oE '("status":")[^"]*' | awk -F '"' '{print $NF}')
[ -z "$TASK_URL" ] && STATUS='FAILED'
echo 'Upload Status : '$STATUS
if [[ $STATUS != SUCCESS ]]; then
  exit 1;
fi
