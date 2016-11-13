@REM @file
@REM   Windows batch file to To configure UDK.
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
REM Check if exist all template files
if NOT exist %EDK_TOOLS_PATH%\Conf\target.template (
  echo Error: target.template is missing at folder %EDK_TOOLS_PATH%\Conf\
  exit /B 1
)
if NOT exist %EDK_TOOLS_PATH%\Conf\tools_def.template (
  echo Error: tools_def.template is missing at folder %EDK_TOOLS_PATH%\Conf\
  exit /B 1
)
if NOT exist %EDK_TOOLS_PATH%\Conf\build_rule.template (
  echo Error: build_rule.template is missing at folder %EDK_TOOLS_PATH%\Conf\
  exit /B 1
)

if /I "%1"=="RECONFIG" (
  echo. Over-writing UDK configurations %WORKSPACE%\Conf using the default template files.
  echo   over-write ... target.template to %WORKSPACE%\Conf\target.txt
  copy /Y %EDK_TOOLS_PATH%\Conf\target.template %WORKSPACE%\Conf\target.txt > nul
  echo   over-write ... tools_def.template to %WORKSPACE%\Conf\tools_def.txt
  copy /Y %EDK_TOOLS_PATH%\Conf\tools_def.template %WORKSPACE%\Conf\tools_def.txt > nul
  echo   over-write ... build_rule.template to %WORKSPACE%\Conf\build_rule.txt
  copy /Y %EDK_TOOLS_PATH%\Conf\build_rule.template %WORKSPACE%\Conf\build_rule.txt > nul
) else (
  echo. Creating UDK configurations to %WORKSPACE%\Conf using the default template files
  echo   copying ... target.template to %WORKSPACE%\Conf\target.txt
  copy %EDK_TOOLS_PATH%\Conf\target.template %WORKSPACE%\Conf\target.txt > nul
  echo   copying ... tools_def.template to %WORKSPACE%\Conf\tools_def.txt
  copy %EDK_TOOLS_PATH%\Conf\tools_def.template %WORKSPACE%\Conf\tools_def.txt > nul
  echo   copying ... build_rule.template to %WORKSPACE%\Conf\build_rule.txt
  copy %EDK_TOOLS_PATH%\Conf\build_rule.template %WORKSPACE%\Conf\build_rule.txt > nul
)

exit /B 0