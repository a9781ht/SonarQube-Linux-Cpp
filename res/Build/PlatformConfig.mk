##########################################
## Target platform Configuration
##########################################
#
# Global variable of target platform
#
export G_TargetPlatform
export G_CCompiler
export G_CLinker_exe
export G_CLinker_dll
export G_CLinker_lib
export G_Stripper
export G_PreprocessorDef
export G_MachineOpt
export G_SysDependency

##########################################
#
# To describe all support target platform
#
_PlatformList := Linux_x64 Linux_iMX6DL_A9 Linux_iMX8MP_A53 Linux_AM625_A53

.PHONY: $(_PlatformList)

##########################################
#
# Linux x64 platform setting
#
Linux_x64:
	@:
	$(eval G_TargetPlatform := Linux_x64)
	$(eval G_CCompiler := g++)
	$(eval G_CLinker_exe := g++)
	$(eval G_CLinker_dll := g++)
	$(eval G_CLinker_lib := ar)
	$(eval G_Stripper := strip)
	$(eval G_PreprocessorDef := -DUNICODE -D_UNICODE)
	$(eval G_MachineOpt := -m64 -pthread)
	$(eval G_SysDependency := -lrt -ldl)
