##########################################
## Project Configuration
##########################################
#
# Include project other property
#
include ../../../res/Build/SDKSettings.mk

##########################################
#
# Project common property
#

# Project name
ProjectName := MyProject

# Config type: only select one type (e.g. exe, dll, lib) to enter
#	exe: Application
#	dll: Dynamics library
#	lib: Static library
ConfigType := exe

# Target file full name
TargetName := $(ProjectName)

ifeq ($(ConfigType), exe)
TargetExt := .out
TargetFile := $(TargetName)$(TargetExt)
else ifeq ($(ConfigType), dll)
TargetExt := .so
TargetFile := $(addprefix lib, $(TargetName)$(TargetExt))
else ifeq ($(ConfigType), lib)
TargetExt := .a
TargetFile := $(addprefix lib, $(TargetName)$(TargetExt))
endif

# Export map file full name
ifeq ($(ConfigType), dll)
ExpMapExt := .expmap
ExpMapFile := $(TargetName)$(ExpMapExt)
endif

##########################################
#
# Project compile - general option
# (The variable name use "Debug_" or "Release_" prefix word, and separate values with space)
#
Debug_LanguageOpt := -std=c++11 -fsigned-char
Debug_DebuggingOpt := -g3
Debug_OptimizationOpt := -O0
Debug_WarningOpt := -Wall
Debug_CodeGenOpt := -fPIC

Release_LanguageOpt := -std=c++11 -fsigned-char
Release_DebuggingOpt :=
Release_OptimizationOpt := -O3
Release_WarningOpt := -Wall
Release_CodeGenOpt := -fPIC

##########################################
#
# Project compile - additional option
# (The variable name use "Debug_" or "Release_" prefix word, and separate values with space)
#
Debug_Additional_IncludeDir := ./
Debug_PreprocessorDef := DEBUG

Release_Additional_IncludeDir := ./
Release_PreprocessorDef := NDEBUG

##########################################
#
# Project link - general option
#	1. Standard library or system library dependency
#	2. Write only "-l[LibraryName]", which no prefix lib and suffix .a/.so description
StdSys_DepLibName :=

##########################################
#
# Project link - dependency for internal resource
#	1. Internal dependency of static/shared library in the same solution for this project
#	2. Write only full file name (e.g. libX.a, libX.so) and separate values with space
Internal_DepLibFiles :=

##########################################
#
# Project link - dependency for external resource
# (The variable name use "Debug_" or "Release_" prefix word, and separate values with space)
#

# Additional dependency of static/shared library of external directory path
Debug_Additional_LibraryDir :=
Release_Additional_LibraryDir :=

# Additional dependency of static/shared library, which is external resource for this project and solution
# Write only full file name (e.g. libX.a, libX.so) and separate values with space
Debug_Additional_DepLibFiles :=
Release_Additional_DepLibFiles :=

##########################################
#
# Project link - additional option
# (The variable name use "Debug_" or "Release_" prefix word, and separate values with space)
#

# Remove the redundant symbols and other data from target executable file or shared library (static library will ignore this setting)
# Write "yes" represent to remove and empty will do nothing
Debug_Remove_RedundantInfo :=
Release_Remove_RedundantInfo := yes

##########################################
#
# Project pre-link event
#	1. The function name use "Debug_" or "Release_" prefix word
#	2. "make" call this function with 1 argument input
#		2.1. $(1): Output target file with path
#
define Debug_PreLinkEvent
endef

define Release_PreLinkEvent
endef

##########################################
#
# Project post-build event
#	1. The function name use "Debug_" or "Release_" prefix word
#	2. "make" call this function with 1 argument input
#		2.1. $(1): Output target file with path
#
define Debug_PostBuildEvent
@mkdir -p $(MySolution_Bin)
@cp -fv $(1) $(MySolution_Bin)
endef

define Release_PostBuildEvent
@mkdir -p $(MySolution_Bin)
@cp -fv $(1) $(MySolution_Bin)
endef
