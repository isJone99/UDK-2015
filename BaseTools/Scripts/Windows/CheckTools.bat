@REM @file
@REM   Windows batch file to Check base tools.
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
if NOT exist "%EDK_TOOLS_PATH%\Bin"                             exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\BootSectImage.exe"     exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\build.exe"             exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\EfiLdrImage.exe"       exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\EfiRom.exe"            exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenBootSector.exe"     exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenFds.exe"            exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenFfs.exe"            exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenFv.exe"             exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenFw.exe"             exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenPage.exe"           exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenSec.exe"            exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\GenVtf.exe"            exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\Split.exe"             exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\TargetTool.exe"        exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\TianoCompress.exe"     exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\Trim.exe"              exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\VfrCompile.exe"        exit /B 1
IF NOT EXIST "%EDK_TOOLS_PATH%\Bin\Win32\VolInfo.exe"           exit /B 1

exit /B 0