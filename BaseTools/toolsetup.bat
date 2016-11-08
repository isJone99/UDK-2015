@REM @file
@REM   This stand-alone program is typically called by the edksetup.bat file, 
@REM   however it may be executed directly from the BaseTools project folder
@REM   if the file is NOT executed within a WORKSPACE\BaseTools folder.
@REM
@REM Copyright (c) 2006 - 2013, Intel Corporation. All rights reserved.<BR>
@REM
@REM This program and the accompanying materials are licensed and made available
@REM under the terms and conditions of the BSD License which accompanies this 
@REM distribution.  The full text of the license may be found at:
@REM   http://opensource.org/licenses/bsd-license.php
@REM
@REM THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR 
@REM IMPLIED.
@REM

@echo off
pushd .

@REM ##############################################################
@REM # You should NOT have to modify anything below this line
@REM #
if /I "%1"=="-h"      goto Usage
if /I "%1"=="/h"      goto Usage
if /I "%1"=="-help"   goto Usage
if /I "%1"=="/help"   goto Usage
if /I "%1"=="?"       goto Usage
if /I "%1"=="--help"  goto Usage
:Loop
  if "%1"=="" goto Check_WORKSPACE
  if /I "%1"=="--nt32" (
    @REM Ignore --nt32 flag
    shift
    goto Loop
  )
  if /I "%1"=="RawTools" (
    set RawTools=TRUE
    shift
    goto Loop
  )
  if /I "%1"=="Reconfig" (
    set RECONFIG=TRUE
    shift
    goto Loop
  )
  if /I "%1"=="BuildTools" (
    set BuildTools=TRUE
    shift
    goto Loop
  )
  if /I "%1"=="RebuildTools" (
    set RebuildTools=TRUE
    shift
    goto Loop
  )
  if NOT defined BASE_TOOLS_PATH (
    if exist %1\Source (
      set BASE_TOOLS_PATH=%1
      shift
      goto Loop
    )
  )
  if NOT defined EDK_TOOLS_PATH (
    if exist %1\Bin\Win32 (
      set EDK_TOOLS_PATH=%1
      shift
      goto Loop
    ) 
  )
  if "%1"=="" (goto Check_WORKSPACE) else (
    echo.
    echo !!! ERROR !!! Unknown argument, %1 !!!
    echo.
    goto End
  )
goto Loop

@REM
@REM Check the required system environment variables
@REM

:Check_WORKSPACE
  REM
  REM This work shall be done in edksetup.bat. Now check the result.
  REM
  if NOT defined WORKSPACE (
    echo !!! WARNING !!! WORKSPACE environment variable was NOT set !!!
    goto End
  ) else if NOT exist %WORKSPACE% (
    echo.
    echo !!! ERROR !!! WORKSPACE is set but NOT exist !!!
    echo.
    goto End
  )
  if NOT defined EDK_TOOLS_PATH (
    echo !!! WARNING !!! EDK_TOOLS_PATH environment variable was NOT set !!!
    goto End
  ) else if NOT exist %EDK_TOOLS_PATH% (
    goto Setup_EDK_TOOLS_PATH_From_WORKSPACE
  ) else (
    goto Setup_PATH
  )
:Setup_EDK_TOOLS_PATH_From_WORKSPACE
  REM
  REM if no EDK_TOOLS_PATH, but WORKSPACE was set.
  REM
  if defined WORKSPACE (
    if exist %WORKSPACE%\BaseTools\Bin (
      set EDK_TOOLS_PATH=%WORKSPACE%\BaseTools
    ) else (
      echo.
      echo !!! ERROR !!! No tools path available. Please set EDK_TOOLS_PATH !!!
      echo.
      goto End
    )
  ) else if defined BASE_TOOLS_PATH (
    set EDK_TOOLS_PATH=%BASE_TOOLS_PATH%
  ) else (
    echo.
    echo !!! ERROR !!! Neither BASE_TOOLS_PATH nor EDK_TOOLS_PATH are set. !!!
    echo.
    goto End
  )
  if exist %EDK_TOOLS_PATH% (
    goto Setup_PATH
  ) else (
    echo !!! ERROR !!! EDK_TOOLS_PATH is set but NOT exist !!!
    goto End
  ) 
:Setup_PATH
  set PATH=%EDK_TOOLS_PATH%\Bin;%EDK_TOOLS_PATH%\Bin\Win32;%PATH%
  echo.
  echo            PATH = %PATH%
  echo       WORKSPACE = %WORKSPACE%
  echo  EDK_TOOLS_PATH = %EDK_TOOLS_PATH%

REM
REM copy *.template to %WORKSPACE%\Conf
REM

if NOT exist %WORKSPACE%\Conf (
  mkdir %WORKSPACE%\Conf
) else if defined RECONFIG (
  echo.
  echo  Over-writing the files in the folder ^"WORKSPACE\Conf^" using the default template files.
  echo.
)

if NOT exist %WORKSPACE%\Conf\target.txt (
  echo copying ... target.template to %WORKSPACE%\Conf\target.txt
  if NOT exist %EDK_TOOLS_PATH%\Conf\target.template (
    echo Error: target.template is missing at folder %EDK_TOOLS_PATH%\Conf\
  )
  copy %EDK_TOOLS_PATH%\Conf\target.template %WORKSPACE%\Conf\target.txt > nul
) else (
  if defined RECONFIG echo over-write ... target.template to %WORKSPACE%\Conf\target.txt
  if defined RECONFIG copy /Y %EDK_TOOLS_PATH%\Conf\target.template %WORKSPACE%\Conf\target.txt > nul
)

if NOT exist %WORKSPACE%\Conf\tools_def.txt (
  echo copying ... tools_def.template to %WORKSPACE%\Conf\tools_def.txt
  if NOT exist %EDK_TOOLS_PATH%\Conf\tools_def.template (
    echo Error: tools_def.template is missing at folder %EDK_TOOLS_PATH%\Conf\
  )
  copy %EDK_TOOLS_PATH%\Conf\tools_def.template %WORKSPACE%\Conf\tools_def.txt > nul
) else (
  if defined RECONFIG echo over-write ... tools_def.template to %WORKSPACE%\Conf\tools_def.txt
  if defined RECONFIG copy /Y %EDK_TOOLS_PATH%\Conf\tools_def.template %WORKSPACE%\Conf\tools_def.txt > nul
)

if NOT exist %WORKSPACE%\Conf\build_rule.txt (
  echo copying ... build_rule.template to %WORKSPACE%\Conf\build_rule.txt
  if NOT exist %EDK_TOOLS_PATH%\Conf\build_rule.template (
    echo Error: build_rule.template is missing at folder %EDK_TOOLS_PATH%\Conf\
  )
  copy %EDK_TOOLS_PATH%\Conf\build_rule.template %WORKSPACE%\Conf\build_rule.txt > nul
) else (
  if defined RECONFIG echo over-write ... build_rule.template to %WORKSPACE%\Conf\build_rule.txt
  if defined RECONFIG copy /Y %EDK_TOOLS_PATH%\Conf\build_rule.template %WORKSPACE%\Conf\build_rule.txt > nul
)

@REM
@REM Test if we are going to have to do a build
@REM
if defined BuildTools                                           goto CheckBaseToolBuildEnv
if NOT exist "%EDK_TOOLS_PATH%\Bin"                             goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\BootSectImage.exe"     goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\build.exe"             goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\EfiLdrImage.exe"       goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\EfiRom.exe"            goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenBootSector.exe"     goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenFds.exe"            goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenFfs.exe"            goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenFv.exe"             goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenFw.exe"             goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenPage.exe"           goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenSec.exe"            goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenVtf.exe"            goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\Split.exe"             goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\TargetTool.exe"        goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\TianoCompress.exe"     goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\Trim.exe"              goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\VfrCompile.exe"        goto CheckBaseToolBuildEnv
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\VolInfo.exe"           goto CheckBaseToolBuildEnv
::IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\Fpd2Dsc.exe"           goto CheckBaseToolBuildEnv
::IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\MigrationMsa2Inf.exe"  goto CheckBaseToolBuildEnv
goto End

:CheckBaseToolBuildEnv
  if NOT defined BASE_TOOLS_PATH (
    if NOT exist "%EDK_TOOLS_PATH%\Source\C\Makefile" (
      echo.
      echo !!! ERROR !!! CanNOT build BaseTools applications - No source files !!!
      echo.
      goto End
    )
    set BASE_TOOLS_PATH=%EDK_TOOLS_PATH%
  )
  if NOT defined PYTHON_HOME (
    echo.
    echo  !!! ERROR !!! PYTHON_HOME is required to build or execute the tools, please set it. !!!
    echo.
    goto End
  ) else if NOT exist %PYTHON_HOME%\python.exe (
    echo.
    echo  !!! ERROR !!! PYTHON-2.7.12 is required to build or execute the tools, please install it. !!!
    echo.
    goto End
  )
  set PYTHONPATH=%BASE_TOOLS_PATH%\Source\Python
  set PYTHON_PATH=%PYTHONPATH%

  if defined RawTools goto PythonScriptAsBaseTools
  
  @REM We have Python, now test for FreezePython application
  if NOT defined PYTHON_FREEZER_PATH (
    @REM see if we can find cxFreeze
    if NOT exist "%PYTHON_HOME%\Scripts\cxfreeze.bat" (
      pushd
      cd "%PYTHON_HOME%\Scripts
      pip install cx_Freeze
      if exist cxfreeze-postinstall (%PYTHON_HOME%\python.exe cxfreeze-postinstall)
      popd
    )
    if exist "%PYTHON_HOME%\Scripts\cxfreeze.bat" (
      set PYTHON_FREEZER_PATH=%PYTHON_HOME%\Scripts
    )
  )
  @REM Python is already.
  echo     BASE_TOOLS_PATH = %BASE_TOOLS_PATH%
  echo         PYTHON_PATH = %PYTHON_PATH%
  echo         PYTHON_HOME = %PYTHON_HOME%
  echo PYTHON_FREEZER_PATH = %PYTHON_FREEZER_PATH%
  echo.
  call "%EDK_TOOLS_PATH%\get_vsvars.bat"
  if NOT defined VCINSTALLDIR (
    @echo.
    @echo !!! ERROR !!!! CanNOT find Visual Studio, required to build C tools !!!
    @echo.
    goto End
  )
  if NOT defined RebuildTools goto BuildBaseTools
  @REM CleanAndBuild
  pushd .
  cd %BASE_TOOLS_PATH%
  call nmake cleanall
  del /f /q %BASE_TOOLS_PATH%\Bin\Win32\*.*
  popd
  @REM Let CleanAndBuild fall through to BuildBaseTools

:BuildBaseTools
  pushd .
  cd %BASE_TOOLS_PATH%
  call nmake c
  popd
  if defined PYTHON_FREEZER_PATH (
    echo Building BaseTools from PYTHON to EXE for Windows.
    pushd .
    cd %BASE_TOOLS_PATH%
    call nmake python
    popd
  ) else (
    echo.
    echo !!! WARNING !!! CanNOT make executable from Python code, executing python scripts instead !!!
    echo.
  )
  goto End

:PythonScriptAsBaseTools
  echo.
  echo !!! WARNING !!! Will NOT compile PYTHON programs to .exe. Will run PYTHON scripts for EDKII building.
  echo.
  set PATH=%PYTHON_PATH%\Trim;%PYTHON_PATH%\GenFds;%PYTHON_PATH%\build;%PATH%
  set PATHEXT=%PATHEXT%;.py
  goto End

:Usage
  echo.
  echo  Usage: "%0 [-h | -help | --help | /h | /help | /?] [ Rebuild | ForceRebuild ] [Reconfig] [base_tools_path [edk_tools_path]]"
  echo.
  echo         base_tools_path    --BASE_TOOLS_PATH will be set to this path. 
  echo         edk_tools_path     --EDK_TOOLS_PATH will be set to this path.
  echo         Reconfig           --Use tempalte to reconfig EDKII build option.
  echo         RawTools           --Use python scripts as basetools.
  echo         RebuildTools       --Use makefile rules to rebuild basetools.
  echo         BuildTools         --Clean and rebuild basetools.
  echo.

:End
set Reconfig=
set RawTools=
set BuildTools=
set RebuildTools=
popd
