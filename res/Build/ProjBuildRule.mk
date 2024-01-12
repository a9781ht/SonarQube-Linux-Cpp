##########################################
## Project Build Rule
## The environment path is the same as project path
##########################################
#
# Include project configuration file
#
include ProjConfig.mk
include ProjSrcFiles.mk

##########################################
#
# Decide the object files (*.o) and its dependency description
# files (*.d) from project source files (*.cpp)
#
ObjFiles := $(SrcFiles:%.cpp=%.o)
ObjDepFiles := $(SrcFiles:%.cpp=%.d)

##########################################
#
# Check the parameter whether is null
#
NullParamCheck :=\
 NULL_PLATFORM_CHECK\
 NULL_CONFIGMODE_CHECK\

.PHONY: $(NullParamCheck)

# Check [Platform] term by $(G_TargetPlatform) value
NULL_PLATFORM_CHECK:
	$(call CHECK_NULL,$(G_TargetPlatform),[Platform] is unspecified)

# Check [ConfigMode] term by $(G_ConfigMode) value
NULL_CONFIGMODE_CHECK:
	$(call CHECK_NULL,$(G_ConfigMode),[ConfigMode] is unspecified)

# This function check null input and print error message
# if $(1) is null, then print $(2) error message
define CHECK_NULL
$(if $(1),\
\
,\
$(error $(2))\
)
endef

##########################################
#
# Project build environment setting
#
TargetPlatform = $(G_TargetPlatform)
CCompiler = $(G_CCompiler)
CLinker = $(G_CLinker_$(ConfigType))
Stripper = $(G_Stripper)
PreprocessorDef = $(G_PreprocessorDef)
MachineOpt = $(G_MachineOpt)
SysDependency = $(G_SysDependency)
ConfigMode = $(G_ConfigMode)

# Decide intermediate directory and output directory path
IntDir = ./$(TargetPlatform)_$(ConfigMode)/
OutDir = ../$(TargetPlatform)_$(ConfigMode)/
IntSubDirs = $(addprefix $(IntDir), $(filter-out ./, $(dir $(ObjFiles))))

# Decide output target file with path
OutTarget = $(OutDir)$(TargetFile)

##########################################
#
# Decide compile options
#
LanguageOpt = $($(ConfigMode)_LanguageOpt)
DebuggingOpt = $($(ConfigMode)_DebuggingOpt)
OptimizationOpt = $($(ConfigMode)_OptimizationOpt)
WarningOpt = $($(ConfigMode)_WarningOpt)
CodeGenOpt = $($(ConfigMode)_CodeGenOpt)
ObjDepFilesGenOpt = -MMD -MP -MF "$(@:%.o=%.d)" -MT "$@"

Additional_IncludeDir = $(addprefix -I, $($(ConfigMode)_Additional_IncludeDir))
PreprocessorDef += $(addprefix -D, $($(ConfigMode)_PreprocessorDef))

CCompileOpt = -c $(LanguageOpt) $(DebuggingOpt) $(OptimizationOpt) $(WarningOpt) $(Additional_IncludeDir) $(PreprocessorDef) $(CodeGenOpt) $(ObjDepFilesGenOpt) $(MachineOpt)

##########################################
#
# Decide link options
#

# 1. The $(OutDir) for $(Internal_DepLibFiles)
# 2. The $(*_Additional_LibraryDir) for $(*_Additional_DepLibFiles)
Link_LibraryDir = $(addprefix -L, $(OutDir) $($(ConfigMode)_Additional_LibraryDir))

# All link library dependency
Link_Dependency =\
 -Wl,--start-group -Wl,--whole-archive $(addprefix -l:, $(Internal_DepLibFiles)) -Wl,--no-whole-archive -Wl,--end-group\
 -Wl,--start-group $(addprefix -l:, $($(ConfigMode)_Additional_DepLibFiles)) -Wl,--end-group\
 $(StdSys_DepLibName)\
 $(SysDependency)\

ifeq ($(ConfigType), exe)
CLinkOpt =\
 -Wl,--as-needed -Wl,--no-undefined -Wl,--allow-shlib-undefined\
 -Wl,-rpath,'$$ORIGIN' $(Link_LibraryDir) $(MachineOpt)
Remove_RedundantInfo = $($(ConfigMode)_Remove_RedundantInfo)
else ifeq ($(ConfigType), dll)
CLinkOpt =\
 -shared -Wl,-soname,$(TargetFile) -Wl,--version-script,$(ExpMapFile)\
 -Wl,--as-needed -Wl,--no-undefined -Wl,--allow-shlib-undefined\
 -Wl,-rpath,'$$ORIGIN' $(Link_LibraryDir) $(MachineOpt)
Remove_RedundantInfo = $($(ConfigMode)_Remove_RedundantInfo)
else ifeq ($(ConfigType), lib)
CLinkOpt := -rcs
Remove_RedundantInfo :=
else
$(error Unknown config type "$(ConfigType)")
endif

##########################################
#
# Decide strip options
#
StripOpt := -s

##########################################
#
# Include object dependency description files (if *.d exist)
#
ifneq ($(strip $(ObjDepFiles)),)
-include $(addprefix $(IntDir), $(ObjDepFiles))
endif

##########################################
#
# Project build prepare
#
.PHONY: BUILD_PREPARE
BUILD_PREPARE: $(NullParamCheck)
	@mkdir -p $(OutDir) $(IntDir) $(IntSubDirs)

#
# Project build start info
#
.PHONY: BUILD_START
BUILD_START: BUILD_PREPARE
	@echo ">\e[42;30m-- Build started: Project: $(ProjectName), Configuration: $(ConfigMode) $(TargetPlatform) --\e[0m"

#
# Project build
#
.PHONY: BUILD
BUILD: BUILD_START
	@$(MAKE) --silent $(OutTarget)

#
# Project build finish info
#
.PHONY: BUILD_FINISH
BUILD_FINISH: BUILD
	@echo ">\e[42;30m$(ProjectName) build finished\e[0m"

##########################################
#
# Decide dependency files for the output file of compiler and linker
#
Proj_CompilerRefFiles := ProjConfig.mk ProjSrcFiles.mk
Proj_LinkerRefFiles := ProjConfig.mk $(ExpMapFile)

Proj_CompileObjs = $(addprefix $(IntDir), $(ObjFiles))
Proj_InternalDepLibs = $(addprefix $(OutDir), $(Internal_DepLibFiles))
Proj_AdditionalDepLibs = $($(ConfigMode)_Additional_DepLibFiles)

#
# Add library search path for $(*_Additional_DepLibFiles) searching
#	1. Add specified path, that make can search lib%.a and lib%.so pattern in it
#		1.1. Using vpath syntax with a pattern and several searching path
#	2. Replace ' ' to ':' for several path separation for vpath
#		2.1. To replace ' ' to ':' by using $(subst) and "$() $()" represents space
#
ifeq ($(ConfigType), exe)
Additional_LibraryDir := $(subst $() $(),:,$($(ConfigMode)_Additional_LibraryDir))
vpath lib%.a $(Additional_LibraryDir)
vpath lib%.so $(Additional_LibraryDir)
else ifeq ($(ConfigType), dll)
Additional_LibraryDir := $(subst $() $(),:,$($(ConfigMode)_Additional_LibraryDir))
vpath lib%.a $(Additional_LibraryDir)
vpath lib%.so $(Additional_LibraryDir)
else ifeq ($(ConfigType), lib)
# Do nothing
else
$(error Unknown config type "$(ConfigType)")
endif

##########################################
#
# Project build - Linker Processing
#
$(OutTarget): $(Proj_CompileObjs) $(Proj_InternalDepLibs) $(Proj_AdditionalDepLibs) $(Proj_LinkerRefFiles)
	@$(MAKE) --no-print-directory PRE_LINK

ifeq ($(ConfigType), exe)
	@echo ">Linking..."
	@$(CLinker) $(CLinkOpt) -o $@ $(Proj_CompileObjs) $(Link_Dependency)
else ifeq ($(ConfigType), dll)
	@echo ">Linking..."
	@$(CLinker) $(CLinkOpt) -o $@ $(Proj_CompileObjs) $(Link_Dependency)
else ifeq ($(ConfigType), lib)
	@echo ">Creating library..."
	@$(CleanCmd) $@
	@$(CLinker) $(CLinkOpt) $@ $(Proj_CompileObjs)
else
	$(error Unknown config type "$(ConfigType)")
endif

ifeq ($(findstring yes, $(Remove_RedundantInfo)), yes)
	@echo ">Stripping..."
	@$(Stripper) $(StripOpt) $@
endif

	@$(MAKE) --no-print-directory POST_BUILD

#
# Project build - Compiler Processing
#
$(IntDir)%.o: %.cpp $(Proj_CompilerRefFiles)
	@echo ">Compiling $<..."
	@$(CCompiler) $(CCompileOpt) -o $@ $<

##########################################
#
# Project pre-link processing
#
.PHONY: PRE_LINK
PRE_LINK: $(NullParamCheck)
	@:
	$(eval BuildEventInfo := >Performing Pre-Link Event...)
	$(if $($(ConfigMode)_PreLinkEvent),\
	$(call BuildEventTask,$(BuildEventInfo),$(ConfigMode)_PreLinkEvent)\
	)

#
# Project post-build processing
#
.PHONY: POST_BUILD
POST_BUILD: $(NullParamCheck)
	@:
	$(eval BuildEventInfo := >Performing Post-Build Event...)
	$(if $($(ConfigMode)_PostBuildEvent),\
	$(call BuildEventTask,$(BuildEventInfo),$(ConfigMode)_PostBuildEvent)\
	)

#
# Project build event function
#	1. The function perform user-defined build event task
#	2. This function has 2 arguments input
#		2.1. $(1): The build event task information
#		2.2. $(2): The function name of user-defined build event task
#	3. Call user-defined build event task with below parameter input
#		3.1. Output target file with path
#
define BuildEventTask
@echo "$(1)"
$(call $(2),$(OutTarget))
endef

##########################################
#
# Project clean
#
CleanCmd := rm -rf

.PHONY: CLEAN
CLEAN: $(NullParamCheck)
	@echo ">\e[43;30m-- Clean started: Project: $(ProjectName), Configuration: $(ConfigMode) $(TargetPlatform) --\e[0m"
	@$(CleanCmd) $(OutTarget) $(IntDir)*.o $(IntDir)*.d $(addsuffix *.o, $(IntSubDirs)) $(addsuffix *.d, $(IntSubDirs))
	@echo ">\e[43;30m$(ProjectName) clean finished\e[0m"

##########################################
#
# The action of build rule
# According the $(ProjectBuildConfig) to decide doing run action or skip action
#
.PHONY: ProjBuild ProjClean

#
# [Run action]
#
ifeq ($(findstring |Y|$(TargetPlatform)|$(ConfigMode)|, $(ProjectBuildConfig)), |Y|$(TargetPlatform)|$(ConfigMode)|)

ProjBuild: BUILD_FINISH

ProjClean: CLEAN

#
# [Skip action]
#
else

ProjBuild: $(NullParamCheck)
	@echo ">\e[46;30m-- Build skipped: Project: $(ProjectName), Configuration: $(ConfigMode) $(TargetPlatform) --\e[0m"

ProjClean: $(NullParamCheck)
	@echo ">\e[46;30m-- Clean skipped: Project: $(ProjectName), Configuration: $(ConfigMode) $(TargetPlatform) --\e[0m"

endif
