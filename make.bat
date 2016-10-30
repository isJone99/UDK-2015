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
  if /I "%1"=="RawTools" (
    set EdkSetupOption=RawTools
    shift
    goto loop
  )
  if /I "%1"=="BuilTools" (
    set EdkSetupOption=BuildTools
    shift
    goto loop
  )
  if /I "%1"=="RebuildTools" (
    set EdkSetupOption=RebuildTools
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
    shift
    shift
    goto loop
  )
@REM Karl's Option
  if /I "%1"=="run" (
    set RunFlag=TRUE
    shift
    goto loop
  )
::endloop

if NOT defined EdkSetupFlag (
  call edksetup.bat --nt32 %EdkSetupOption%
  set EdkSetupFlag=TRUE
) else if defined EdkSetupOption (
  call edksetup.bat --nt32 %EdkSetupOption%
)

if defined RunFlag goto run

:build
  build %PLATFORMFILE% %BUILDTARGET% %TARGETARCH% %TOOLCHAIN%
goto end

:run
  build run %PLATFORMFILE% %BUILDTARGET% %TARGETARCH% %TOOLCHAIN%
goto end

:error
  echo   ------------------------------------------------------------------------
  echo   Usage:
  echo     make [EdkSetupOption] [EdkBuildOption]
  echo.
  echo   [EdkSetupOption] is zero or more of the following:
  echo     reconfig           --Use tempalte to reconfig EDKII build option.
  echo     RawTools           --Use python scripts as basetools.
  echo     RebuildTools       --Use makefile rules to rebuild basetools.
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
  set        RunFlag=
  exit /B %SCRIPT_ERROR%