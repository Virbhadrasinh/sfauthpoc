@REM ----------------------------------------------------------------------------
@REM Copyright 2001-2004 The Apache Software Foundation.
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at
@REM
@REM      http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.
@REM ----------------------------------------------------------------------------
@REM

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\repo

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\javax\servlet\servlet-api\2.5\servlet-api-2.5.jar;"%REPO%"\org\mortbay\jetty\jsp-2.1-glassfish\2.1.v20100127\jsp-2.1-glassfish-2.1.v20100127.jar;"%REPO%"\org\eclipse\jdt\core\compiler\ecj\3.5.1\ecj-3.5.1.jar;"%REPO%"\org\mortbay\jetty\jsp-api-2.1-glassfish\2.1.v20100127\jsp-api-2.1-glassfish-2.1.v20100127.jar;"%REPO%"\ant\ant\1.6.5\ant-1.6.5.jar;"%REPO%"\com\fasterxml\jackson\core\jackson-core\2.8.5\jackson-core-2.8.5.jar;"%REPO%"\com\fasterxml\jackson\core\jackson-databind\2.8.5\jackson-databind-2.8.5.jar;"%REPO%"\com\fasterxml\jackson\core\jackson-annotations\2.8.0\jackson-annotations-2.8.0.jar;"%REPO%"\org\eclipse\jetty\jetty-webapp\7.6.0.v20120127\jetty-webapp-7.6.0.v20120127.jar;"%REPO%"\org\eclipse\jetty\jetty-xml\7.6.0.v20120127\jetty-xml-7.6.0.v20120127.jar;"%REPO%"\org\eclipse\jetty\jetty-util\7.6.0.v20120127\jetty-util-7.6.0.v20120127.jar;"%REPO%"\org\eclipse\jetty\jetty-servlet\7.6.0.v20120127\jetty-servlet-7.6.0.v20120127.jar;"%REPO%"\org\eclipse\jetty\jetty-security\7.6.0.v20120127\jetty-security-7.6.0.v20120127.jar;"%REPO%"\org\eclipse\jetty\jetty-server\7.6.0.v20120127\jetty-server-7.6.0.v20120127.jar;"%REPO%"\org\eclipse\jetty\jetty-continuation\7.6.0.v20120127\jetty-continuation-7.6.0.v20120127.jar;"%REPO%"\org\eclipse\jetty\jetty-http\7.6.0.v20120127\jetty-http-7.6.0.v20120127.jar;"%REPO%"\org\eclipse\jetty\jetty-io\7.6.0.v20120127\jetty-io-7.6.0.v20120127.jar;"%REPO%"\asm\asm\3.2\asm-3.2.jar;"%REPO%"\org\json\json\20080701\json-20080701.jar;"%REPO%"\commons-httpclient\commons-httpclient\3.1\commons-httpclient-3.1.jar;"%REPO%"\commons-logging\commons-logging\1.0.4\commons-logging-1.0.4.jar;"%REPO%"\commons-codec\commons-codec\1.4\commons-codec-1.4.jar;"%REPO%"\sfdc\sfdc-canvas-sdk\1.0-SNAPSHOT\sfdc-canvas-sdk-1.0-SNAPSHOT.jar
set EXTRA_JVM_ARGUMENTS=
goto endInit

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% %EXTRA_JVM_ARGUMENTS% -classpath %CLASSPATH_PREFIX%;%CLASSPATH% -Dapp.name="webapp" -Dapp.repo="%REPO%" -Dbasedir="%BASEDIR%" Main %CMD_LINE_ARGS%
if ERRORLEVEL 1 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=1

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@endlocal

:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
