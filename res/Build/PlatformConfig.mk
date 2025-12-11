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

##########################################
#
# Linux i.MX6 DualLite Cortex-A9 platform setting
#
Linux_iMX6DL_A9:
	@:
	$(eval G_TargetPlatform := Linux_iMX6DL_A9)
	$(eval G_CCompiler := arm-none-linux-gnueabi-g++)
	$(eval G_CLinker_exe := arm-none-linux-gnueabi-g++)
	$(eval G_CLinker_dll := arm-none-linux-gnueabi-g++)
	$(eval G_CLinker_lib := arm-none-linux-gnueabi-ar)
	$(eval G_Stripper := arm-none-linux-gnueabi-strip)
	$(eval G_PreprocessorDef := -D__TARGET_CPU_CORTEX_A9 -DIMX6DL -DUNICODE -D_UNICODE -DARM -DUNDER_EL)
	$(eval G_MachineOpt := -marm -march=armv7-a -mcpu=cortex-a9 -mfloat-abi=hard -mfpu=neon-vfpv3 -pthread)
	$(eval G_SysDependency := -lrt -ldl)

##########################################
#
# Linux i.MX8M Plus Cortex-A53 platform setting
#
Linux_iMX8MP_A53:
	@:
	$(eval G_TargetPlatform := Linux_iMX8MP_A53)
	$(eval G_CCompiler := aarch64-oe-linux-g++ --sysroot=$(value AARCH64_OE_LINUX_SDK_SYSROOT))
	$(eval G_CLinker_exe := aarch64-oe-linux-g++ --sysroot=$(value AARCH64_OE_LINUX_SDK_SYSROOT))
	$(eval G_CLinker_dll := aarch64-oe-linux-g++ --sysroot=$(value AARCH64_OE_LINUX_SDK_SYSROOT))
	$(eval G_CLinker_lib := aarch64-oe-linux-ar)
	$(eval G_Stripper := aarch64-oe-linux-strip)
	$(eval G_PreprocessorDef := -D__ARM_ARCH_8A__ -D__TARGET_CPU_CORTEX_A53 -D__ARM_NEON__ -DIMX8MP -DUNICODE -D_UNICODE -DARM -DUNDER_EL)
	$(eval G_MachineOpt := -march=armv8-a -mcpu=cortex-a53+fp+simd+crypto+crc -pthread)
	$(eval G_SysDependency := -lrt -ldl)

##########################################
#
# Linux AM625 Cortex-A53 platform setting
#
Linux_AM625_A53:
	@:
	$(eval G_TargetPlatform := Linux_AM625_A53)
	$(eval G_CCompiler := $(value ARAGO_202304_AARCH64_OE_LINUX_SDK_BINROOT)/aarch64-oe-linux-g++ --sysroot=$(value ARAGO_202304_AARCH64_OE_LINUX_SDK_SYSROOT))
	$(eval G_CLinker_exe := $(value ARAGO_202304_AARCH64_OE_LINUX_SDK_BINROOT)/aarch64-oe-linux-g++ --sysroot=$(value ARAGO_202304_AARCH64_OE_LINUX_SDK_SYSROOT))
	$(eval G_CLinker_dll := $(value ARAGO_202304_AARCH64_OE_LINUX_SDK_BINROOT)/aarch64-oe-linux-g++ --sysroot=$(value ARAGO_202304_AARCH64_OE_LINUX_SDK_SYSROOT))
	$(eval G_CLinker_lib := $(value ARAGO_202304_AARCH64_OE_LINUX_SDK_BINROOT)/aarch64-oe-linux-ar)
	$(eval G_Stripper := $(value ARAGO_202304_AARCH64_OE_LINUX_SDK_BINROOT)/aarch64-oe-linux-strip)
	$(eval G_PreprocessorDef := -D__ARM_ARCH_8A__ -D__TARGET_CPU_CORTEX_A53 -D__ARM_NEON__ -DAM625 -DUNICODE -D_UNICODE -DARM -DUNDER_EL)
	$(eval G_MachineOpt := -march=armv8-a -mcpu=cortex-a53+fp+simd+crypto+crc -pthread)
	$(eval G_SysDependency := -lrt -ldl)
