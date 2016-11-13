@REM @file
@REM   Windows batch file to setup the all required environment variables.
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
if /I "%1"=="-h"      goto error
if /I "%1"=="-help"   goto error
if /I "%1"=="/h"      goto error
if /I "%1"=="/help"   goto error
if /I "%1"=="?"       goto error
if /I "%1"=="--help"  goto error

:loop
@REM EDKII Setup Option
  if /I "%1"=="Reconfig" (
    set EdkSetupOption=Reconfig
    shift
    goto loop
  )
  if /I "%1"=="BuildTools" (
    set EdkSetupOption=BuildTools
    shift
    goto loop
  )
@REM EDKII Build Option
  if /I "%1"=="-p" (
    set PLATFORMFILE=%1 %2
    shift
    shift
    goto loop
  )
  if /I "%1"=="-b" (
    set BUILDTARGET=%1 %2
    shift
    shift
    goto loop
  )
  if /I "%1"=="-a" (
    set TARGETARCH=%1 %2
    shift
    shift
    goto loop
  )
  if /I "%1"=="-t" (
    set TOOLCHAIN=%1 %2
    set VsVar=%2
    shift
    shift
    goto loop
  )
@REM Karl's Option
  if /I "%1"=="run" (
    set RunFlag=TRUE
    shift
    goto loop
  ) else if /I "%1"=="clean" (
    set CleanFlag=TRUE
    shift
    goto loop
  )
  if "%1"=="" (goto edksetup) else (shift)
goto loop
::endloop

:edksetup

@REM when using MYTOOLS, set VsVar here.
if NOT defined VsVar set VsVar=VS2010x86

if NOT defined EdkSetupFlag (
  set EdkSetupFlag=TRUE
  call edksetup.bat %EdkSetupOption%
) else if defined EdkSetupOption (
  call edksetup.bat %EdkSetupOption%
)

if defined RunFlag      goto run
if defined CleanFlag    goto clean

:build
  build %PLATFORMFILE% %BUILDTARGET% %TARGETARCH% %TOOLCHAIN%
goto end

:run
  set RunFlag=
  build run %PLATFORMFILE% %BUILDTARGET% %TARGETARCH% %TOOLCHAIN%
goto end

:clean
  set CleanFlag=
  if exist Build rmdir /S /Q Build
goto end

:error
  echo   ------------------------------------------------------------------------
  echo   Usage:
  echo     make [EdkSetupOption] [EdkBuildOption]
  echo.
  echo   [EdkSetupOption] is zero or more of the following:
  echo     ReConfig           --Use tempalte to reconfig EDKII build option.
  echo     BuildTools         --Clean and rebuild basetools.
  echo.
  echo   [EdkBuildOption] is zero or more of the following:
  echo     -p [PLATFORMFILE]  --Declare the package to be built.
  echo     -b [BUILDTARGET]   --Declare the BUILDTARGET of building image.
  echo     -a [TARGETARCH]    --Declare the TARGETARCH of building image.
  echo     -t [TOOLCHAIN]     --Declare the tool chain for building tool.
  echo.
  echo   You can also execute "make run" to run a built emulator package.
  echo   ------------------------------------------------------------------------

:end
  set EdkSetupOption=
  set   PLATFORMFILE=
  set    BUILDTARGET=
  set     TARGETARCH=
  set      TOOLCHAIN=
  exit /B %SCRIPT_ERROR%
