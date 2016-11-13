@REM @file
@REM   Windows batch file to check basic UDK environment variable.
@REM
@REM Copyright (c) 2016, EfiKarl. All rights reserved.

@REM This program and the accompanying materials
@REM are licensed and made available under the terms and conditions of the BSD License
@REM which accompanies this distribution.  The full text of the license may be found at
@REM http://opensource.org/licenses/bsd-license.php
@REM
@REM THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
@REM
@echo off

echo.
REM
REM This work shall be done in edksetup.bat. Now check the result.
REM
if NOT defined WORKSPACE (
  echo. !!! WARNING !!! WORKSPACE environment variable was NOT set !!!
  exit /B 1
) else if NOT exist %WORKSPACE% (
  echo. !!! ERROR !!! WORKSPACE is set but NOT exist !!!
  exit /B 1
)

  REM
  REM if no EDK_TOOLS_PATH, but WORKSPACE was set.
  REM
if NOT defined EDK_TOOLS_PATH (
  if exist %WORKSPACE%\BaseTools\Bin (
    set EDK_TOOLS_PATH=%WORKSPACE%\BaseTools
  ) else if defined BASE_TOOLS_PATH (
    set EDK_TOOLS_PATH=%BASE_TOOLS_PATH%
  ) else (
    echo. !!! ERROR !!! One of BASE_TOOLS_PATH or EDK_TOOLS_PATH must be set. !!!
    exit /B 1
  )
  if exist %EDK_TOOLS_PATH% (
    goto Setup_PATH
  ) else (
    echo. !!! ERROR !!! EDK_TOOLS_PATH is set but NOT exist !!!
    exit /B 1
  )
)
REM
REM if defined BUILDTOOLS but no BASE_TOOLS_PATH, and WORKSPACE was set.
REM
if /I NOT defined BuildTools goto End
if NOT defined BASE_TOOLS_PATH (
  set BASE_TOOLS_PATH=%EDK_TOOLS_PATH%
)
if NOT exist "%BASE_TOOLS_PATH%\Source\C\Makefile" (
  echo. !!! ERROR !!! Can NOT build BaseTools applications - No source files !!!
  exit /B 1
)

:End
  exit /B 0