##########################################
## Solution Configuration
##########################################
#
# Solution platform and config mode property
#

# To describe all support target platform
_PlatformList := Linux_x64

# To describe all support config mode
_ConfigModeList := Debug Release

##########################################
#
# To describe the all solution of SDK
# 
_AllSDKSlnList :=\
 MySolution\

##########################################
#
# In order to operate all solutions, the SDK phony target is described.
# And then it is dependent on all solutions.
#

# set SDK target as default target
.DEFAULT_GOAL := SDK

.PHONY: SDK
SDK: $(_AllSDKSlnList)

.PHONY: $(_AllSDKSlnList)
$(_AllSDKSlnList): BuildAction

##########################################
#
# The dependency description between each solutions
#
MySolution:
	@$(RunCmd)
