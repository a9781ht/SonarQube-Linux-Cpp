##########################################
## Make File
##########################################
#
# Include configuration file
#
include ../../res/Build/PlatformConfig.mk
include SolutionConfig.mk

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
# To enter target project directory and call project build of build rule file
Proj_Build_Cmd = $(MAKE) --no-print-directory -C "./$$@" ProjBuild;

# [Clean]
# To enter target project directory and call project clean of build rule file
Proj_Clean_Cmd = $(MAKE) --no-print-directory -C "./$$@" ProjClean;

# [Rebuild]
# To rebuild target project by first clean and then build action calling
Proj_Rebuild_Cmd = $(Proj_Clean_Cmd) $(Proj_Build_Cmd)

# [Help]
# To show the using specification of make command
Proj_Help_Cmd =\
 @echo 'Please use "make [Action] [Platform] [ConfigMode] [TargetProj]"';\
 echo '[Action]: $(_ActionList)';\
 echo '[Platform]: $(_PlatformList)';\
 echo '[ConfigMode]: $(_ConfigModeList)';\
 echo '[TargetProj]: $(_AllSlnProjsList)';\

##########################################
#
# Define the action and corresponding run command
#
.PHONY: $(_ActionList)
$(RecurRunAction):
	@:
	$(eval RunCmd = +$(Proj_$@_Cmd))

$(DirectRunAction):
	@$(Proj_$@_Cmd)
