@REM @file
@REM   Windows batch file to build executable base tools for windows.
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
set "BIN_DIR=%EDK_TOOLS_PATH%\Bin\Win32"
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

echo. Rebuilding the EDK II BaseTools...
cd "%BASE_TOOLS_PATH%"
call nmake cleanall

cd "%BASE_TOOLS_PATH%\Source\C"
call nmake -nologo -a -f Makefile
if errorlevel 1 (
  echo Fail to building the C-based BaseTools
  cd "%WORKSPACE%"
  exit /B 1
)

REM Check if PYTHON is ready.
set PYTHONPATH=%BASE_TOOLS_PATH%\Source\Python
if NOT defined PYTHON_HOME (
  echo.  ERROR: PYTHON_HOME is required to build or execute the tools.
  exit /B 1
) else if NOT exist %PYTHON_HOME%\python.exe (
  echo.  ERROR: PYTHON-2.7.12 is required to build or execute the tools.
  exit /B 1
)
REM Set PYTHON_FREEZER_PATH
if NOT exist "%PYTHON_HOME%\Scripts\cxfreeze.bat" (
  cd "%PYTHON_HOME%\Scripts
  pip install cx_Freeze
  if errorlevel 0 (
    %PYTHON_HOME%\python.exe cxfreeze-postinstall
  ) else (
    echo.  ERROR: Fail to install cx_Freeze, check network please.
    exit /B 1
  )
)
if exist "%PYTHON_HOME%\Scripts\cxfreeze.bat" set PYTHON_FREEZER_PATH=%PYTHON_HOME%\Scripts

cd %BASE_TOOLS_PATH%\Source\Python
call nmake -nologo -a -f Makefile
if errorlevel 1 (
  echo. Fail to building the Python-based BaseTools
  cd %WORKSPACE%
  exit /B 1
)

popd

exit /B 0
