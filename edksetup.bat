@REM @file
@REM   Windows batch file to setup a WORKSPACE environment
@REM
@REM Copyright (c) 2006 - 2014, Intel Corporation. All rights reserved.<BR>
@REM This program and the accompanying materials
@REM are licensed and made available under the terms and conditions of the BSD License
@REM which accompanies this distribution.  The full text of the license may be found at
@REM http://opensource.org/licenses/bsd-license.php
@REM
@REM THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
@REM

@REM set CYGWIN_HOME=C:\cygwin

@REM usage: 
@REM   edksetup.bat [--nt32] [AntBuild] [Rebuild] [ForceRebuild] [Reconfig]
@REM if the argument, skip is present, only the paths and the
@REM test and set of environment settings are performed. 

@REM ##############################################################
@REM # You should not have to modify anything below this line
@REM #

@echo off

@REM
@REM Set the WORKSPACE to the current working directory
@REM
pushd .
cd %~dp0

if not defined WORKSPACE (
  @REM set new workspace
  @REM set EDK_TOOLS_PATH
  @REM clear EFI_SOURCE and EDK_SOURCE for the new workspace
  set WORKSPACE=%CD%
  set EFI_SOURCE=
  set EDK_SOURCE=
)
set PYTHON_HOME=C:\Unix\Python
set EDK_TOOLS_PATH=%WORKSPACE%\BaseTools
if %WORKSPACE% == %CD% (
  @REM Workspace is not changed.
  goto ParseArgs
) else (
  echo WARNING: Workspace is not where edksetup in!
)

:ParseArgs
if /I "%1"=="-h"      goto Usage
if /I "%1"=="-help"   goto Usage
if /I "%1"=="/h"      goto Usage
if /I "%1"=="/help"   goto Usage
if /I "%1"=="?"       goto Usage
if /I "%1"=="--help"  goto Usage
if /I "%1"=="--nt32" (goto NT32) else (goto NoNT32)

:NT32
@REM When flag --nt32 is set:
@REM The Nt32 Emluation Platform requires Microsoft Libraries and headers to interface with Windows.
if not defined VCINSTALLDIR (
  if defined VS120COMNTOOLS (
    call "%VS120COMNTOOLS%\vsvars32.bat"
  ) else if defined VS110COMNTOOLS (
    call "%VS110COMNTOOLS%\vsvars32.bat"
  ) else if defined VS100COMNTOOLS (
    call "%VS100COMNTOOLS%\vsvars32.bat"
  ) else if defined VS90COMNTOOLS (
    call "%VS90COMNTOOLS%\vsvars32.bat"
  ) else (
    echo.
    echo !!! WARNING !!! Cannot find Visual Studio !!!
    echo.
  )
)

:NoNT32
if exist "%EDK_TOOLS_PATH%\toolsetup.bat" (call %EDK_TOOLS_PATH%\toolsetup.bat %*) else (goto BadBaseTools)
:Loop
  if "%1"=="" (goto End) else (shift)
goto Loop

:BadBaseTools
  @REM
  @REM Need the BaseTools Package in order to build
  @REM
  @echo.
  @echo !!! ERROR !!! The BaseTools Package was not found !!!
  @echo.
  @echo The script toolsetup.bat must reside in this folder.
  @echo.
goto End

:Usage
  @echo.
  @echo  Usage: "%0 [-h | -help | --help | /h | /help | /?] [--nt32] [Reconfig]"
  @echo         --nt32         Call vsvars32.bat for NT32 platform build.
  @echo.
  @echo         Reconfig       Reinstall target.txt, tools_def.txt and build_rule.txt.
  @echo.
  @echo  Note that target.template, tools_def.template and build_rules.template
  @echo  will only be copied to target.txt, tools_def.txt and build_rule.txt
  @echo  respectively if they do not exist. Use option [Reconfig] to force the copy.
  @echo.
goto End

:End
  popd

