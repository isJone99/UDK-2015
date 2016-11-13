@REM @file
@REM   Windows batch file to find the Visual Studio set up script
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
if NOT defined VsVar set /p VsVar=Which toolchain? 

if        /I %VsVar%==VS2008   (
  set VsVer=VS2008
  set VsX64=TRUE
) else if /I %VsVar%==VS2010    (
  set VsVer=VS2010
  set VsX64=TRUE
) else if /I %VsVar%==VS2015    (
  set VsVer=VS2015
  set VsX64=TRUE
) else if /I %VsVar%==VS2008x86 (
  set VsVer=VS2008
  set VsX64=FALSE
) else if /I %VsVar%==VS2010x86 (
  set VsVer=VS2010
  set VsX64=FALSE
) else if /I %VsVar%==VS2015x86 (
  set VsVer=VS2015
  set VsX64=FALSE
)

REM Check Visual Studio
if /I %VsVer%==VS2015 ( if NOT defined VS140COMNTOOLS goto Error )
if /I %VsVer%==VS2010 ( if NOT defined VS100COMNTOOLS goto Error )
if /I %VsVer%==VS2008 ( if NOT defined  VS90COMNTOOLS goto Error )

REM Set up COMMONTOOLS


REM Set up the VS environment for building Nt32Pkg/Nt32Pkg.dsc to run on an X64 platform
if /I %VsX64%==TRUE (goto True) else (goto False)
:True
  if /I %VsVer%==VS2015 set COMMONTOOLS="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\x86_amd64"
  if /I %VsVer%==VS2010 set COMMONTOOLS="C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\x86_amd64"
  if /I %VsVer%==VS2008 set COMMONTOOLS="C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin\x86_amd64"
  if exist %COMMONTOOLS%\vcvarsx86_amd64.bat (
    echo.
    call %COMMONTOOLS%\vcvarsx86_amd64.bat
  ) else (
    echo ERROR : This script does not exist: %COMMONTOOLS%\vcvarsx86_amd64.bat
    exit /B 1
  )
goto End
:False
  if /I %VsVer%==VS2015 set COMMONTOOLS="%VS140COMNTOOLS%"
  if /I %VsVer%==VS2010 set COMMONTOOLS="%VS100COMNTOOLS%"
  if /I %VsVer%==VS2008 set COMMONTOOLS="%VS90COMNTOOLS%"
  if exist %COMMONTOOLS%\vsvars32.bat (
    echo.
    call %COMMONTOOLS%\vsvars32.bat
  ) else (
    echo. ERROR : This script does not exist: %COMMONTOOLS%\vsvars32.bat
    exit /B 1
  )
goto End

:Error
  echo. ERROR: Microsoft Visual Studio NOT INSTALLED: %VsVer%!
  exit /B 1

:End
  set       VsVar=
  set       VsVer=
  set       VsX64=
  set COMMONTOOLS=
  exit /B 0
