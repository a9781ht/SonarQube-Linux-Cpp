##########################################
## Make File
##########################################
#
# Include configuration file
#
include BuildSDKConfig.mk

##########################################
#
# Define folder path
#

# Set the build log file folder
_LogFolder := ./BuildLog_Linux

##########################################
#
# To describe all support action of make file
#

# The action of recursive run (sub-make invoking) command
#	Note: these action command variables will use "+$(MAKE)" token
#	to invoke sub-make for make processes to communicate
RecurRunAction := Build Clean Rebuild

# The action of direct run command
DirectRunAction := Help

# All support action list
_ActionList := $(RecurRunAction) $(DirectRunAction)

##########################################
#
# Define the action shell command
#

# [Build]
# To enter target solution directory and call solution build
# It will send output to {Logfolder}/{Solution Name}_{TargetPlatform}_{ConfigMode}.txt
Sln_Build_Cmd = $(MAKE) --no-print-directory -C "../Src/$$@/" Build $(TargetPlatform) $(ConfigMode) _$$@_Sln > $(_LogFolder)/$$@_$(TargetPlatform)_$(ConfigMode).txt 2>&1;

# [Clean]
# To enter target solution directory and call solution clean
# It will hide output
Sln_Clean_Cmd = $(MAKE) --no-print-directory -C "../Src/$$@/" Clean $(TargetPlatform) $(ConfigMode) _$$@_Sln > /dev/null;

# [Rebuild]
# To rebuild target solution by first clean and then build action calling
Sln_Rebuild_Cmd = $(Sln_Clean_Cmd) $(Sln_Build_Cmd)

# [Help]
# To show the make command specification form param list
Sln_Help_Cmd =\
 @echo 'Please use "make Action=[Action] TargetPlatform=[Platform] ConfigMode=[ConfigMode]"';\
 echo '[Action]: $(RecurRunAction)';\
 echo '[Platform]: $(_PlatformList)';\
 echo '[ConfigMode]: $(_ConfigModeList)';\

##########################################
#
# Define the direct run action target and corresponding run command
#
.PHONY: $(DirectRunAction)
$(DirectRunAction):
	@$(Sln_$@_Cmd)

##########################################
#
# The action before build
# It will create log file folder, if the folder is not exist
#
.PHONY: PreBuildAction
PreBuildAction:
	@if [ ! -d "$(_LogFolder)" ]; then \
		mkdir -p $(_LogFolder); \
	fi

##########################################
#
# If has Action param, use it to corresponding run command
# The Action must in the action list
#
.PHONY: BuildAction
BuildAction: PreBuildAction
ifeq ($(Action),)
	$(error "No assign action, try 'make Help' for more information")
else ifeq ($(filter $(Action),$(RecurRunAction)),)
	$(error "Unknown action $(Action), try 'make Help' for more information")
else
	@$(eval RunCmd = +$(Sln_$(Action)_Cmd))
endif
