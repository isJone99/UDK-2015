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

@echo off

@REM
@REM Set the WORKSPACE to the current working directory
@REM
pushd .
cd %~dp0

if not defined WORKSPACE (
  @REM set WORKSPACE
  set WORKSPACE=%CD%
  @REM clear EFI_SOURCE and EDK_SOURCE for the new workspace
  set EFI_SOURCE=
  set EDK_SOURCE=
  @REM set PYTHON_HOME for build BaseTools using python script
  set PYTHON_HOME=C:\Unix\Python
)
@REM set EDK_TOOLS_PATH
set EDK_TOOLS_PATH=%WORKSPACE%\BaseTools

if %WORKSPACE% == %CD% (
  @REM Workspace is not changed.
  goto ParseArgs
) else (
  echo WARNING: Workspace is not where edksetup in!
)

:ParseArgs
  if exist "%EDK_TOOLS_PATH%\toolsetup.bat" (call %EDK_TOOLS_PATH%\toolsetup.bat %*) else (goto BadBaseTools)
goto end

:BadBaseTools
  @REM
  @REM Need the BaseTools Package in order to build
  @REM
  @echo.
  @echo ERROR: toolsetup.bat NOT exist in %EDK_TOOLS_PATH%.
  @echo.
goto End

:End
  popd
