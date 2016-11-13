@REM @file
@REM   This stand-alone program is typically called by the edksetup.bat file, 
@REM   however it may be executed directly from the BaseTools project folder
@REM   if the file is NOT executed within a WORKSPACE\BaseTools folder.
@REM
@REM Copyright (c) 2006 - 2015, Intel Corporation. All rights reserved.<BR>
@REM Copyright (c) 2016, EfiKarl. All rights reserved.<BR>
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

REM ##############################################################
REM # You should NOT have to modify anything below this line
REM #
if /I "%1"=="-h"      goto Usage
if /I "%1"=="/h"      goto Usage
if /I "%1"=="-help"   goto Usage
if /I "%1"=="/help"   goto Usage
if /I "%1"=="?"       goto Usage
if /I "%1"=="--help"  goto Usage
:Loop
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
  if "%1"=="" (goto CheckWorkSpace) else (
    echo.
    echo !!! ERROR !!! Unknown argument, %1 !!!
    echo.
    goto End
  )

:CheckWorkSpace
REM
REM Check if we setup UDK basic enviroment variables.
REM
call %EDK_TOOLS_PATH%\Scripts\Windows\CheckEnv.bat
if NOT errorlevel 0 goto End
set PATH=%EDK_TOOLS_PATH%\Bin;%EDK_TOOLS_PATH%\Bin\Win32;%PATH%
echo.
echo            PATH = %PATH%
echo       WORKSPACE = %WORKSPACE%
echo  EDK_TOOLS_PATH = %EDK_TOOLS_PATH%
REM
REM Check if we'd been done a configuration for UDK.
REM
if NOT exist %WORKSPACE%\Conf (
  mkdir %WORKSPACE%\Conf
  Call %EDK_TOOLS_PATH%\Scripts\Windows\ConfigUdk.bat
  if NOT errorlevel 0 goto End
)
if defined RECONFIG (
  Call %EDK_TOOLS_PATH%\Scripts\Windows\ConfigUdk.bat RECONFIG
  if NOT errorlevel 0 goto End
)
REM
REM Get Visual Studio enviroment variables
REM
if NOT defined VCINSTALLDIR  (
  call %EDK_TOOLS_PATH%\Scripts\Windows\GetVsVars.bat %VsVar%
  if NOT errorlevel 0 goto End
)
REM
REM Check if we have executable tools for Windows
REM

call %EDK_TOOLS_PATH%\Scripts\Windows\CheckTools.bat
if NOT errorlevel 0 (
  call %EDK_TOOLS_PATH%\Scripts\Windows\BuildTools.bat
  if NOT errorlevel 0 goto End
) else if defined BuildTools (
  call %EDK_TOOLS_PATH%\Scripts\Windows\BuildTools.bat
  if NOT errorlevel 0 goto End
) else (
  goto end
)

:Usage
  echo.
  echo  Usage: "%0 [-h | -help | --help | /h | /help | /?] [ Rebuild | ForceRebuild ] [Reconfig] [base_tools_path [edk_tools_path]]"
  echo.
  echo         base_tools_path    --BASE_TOOLS_PATH will be set to this path. 
  echo         edk_tools_path     --EDK_TOOLS_PATH will be set to this path.
  echo         Reconfig           --Use tempalte to reconfig EDKII build option.
  echo         BuildTools         --Clean and rebuild basetools.
  echo.

:End
  set Reconfig=
  set BuildTools=
popd
