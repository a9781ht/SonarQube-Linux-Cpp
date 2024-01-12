##########################################
## Solution Configuration
##########################################
#
# Solution common property
#

# Solution name
SolutionName := MySolution

# Solution target name
SolutionTarget := _$(SolutionName)_Sln

##########################################
#
# Solution config mode property
#

# Global variable of config mode
export G_ConfigMode

# To describe all support config mode
_ConfigModeList := Debug Release

# Solution config mode setting
.PHONY: $(_ConfigModeList)
$(_ConfigModeList):
	@:
	$(eval G_ConfigMode := $@)

##########################################
#
# To describe the all projects of solution
#
_AllSlnProjName :=\
 MyProject\

##########################################
#
# All project targets are phony
#
_AllSlnProjsList := $(SolutionTarget) $(_AllSlnProjName)

.PHONY: $(_AllSlnProjsList)

##########################################
#
# In order to operate solution, the $(SolutionTarget) is described.
# And then it is dependent on all projects.
#
$(SolutionTarget): $(_AllSlnProjName)
	@:

##########################################
#
# The dependency description between each projects
#
MyProject:
	@$(RunCmd)
