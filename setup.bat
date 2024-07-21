@echo off
:: -----------------------------------------------------------------
:: --- Set the container name
:: -----------------------------------------------------------------
set NAME="windows-server-sandbox"


:: -----------------------------------------------------------------
:: --- Remove pre-existing instance of container if found via docker ps
:: -----------------------------------------------------------------
echo Checking for pre-existing instance of %NAME%
docker ps | find /i %NAME%
if not errorlevel 1 (
    echo Found pre-existing instance of %NAME% with command docker ps && echo Cleaning previous instance of %NAME% with command docker container && docker stop %NAME% && docker rm %NAME%
) else (
    echo Previous instance of %NAME% not running with command docker ps)


:: -----------------------------------------------------------------
:: --- Remove pre-existing instance of container if found via docker container
:: -----------------------------------------------------------------
docker container ls --all | find /i %NAME%
if not errorlevel 1 (
    echo Found pre-existing instance of %NAME% with command docker container && echo Cleaning previous instance of %NAME% with command docker container && docker container rm %NAME% 
) else (
    echo Previous instance of %NAME% not running with command docker container)


:: -----------------------------------------------------------------
:: --- Check again if the container successfully exited
:: -----------------------------------------------------------------
FOR /F "tokens=* USEBACKQ" %%F IN (`docker ps --filter name^=^^%NAME%$ -q`) DO (
set "result=%%F")
IF "%result%" == "" echo Container %NAME% is not running


:: -----------------------------------------------------------------
:: --- Build the Docker image file using the latest source files
:: -----------------------------------------------------------------
echo Building %NAME%
docker build -t %NAME% -f nginx.Dockerfile .
if %ERRORLEVEL% NEQ 0 echo Error building Dockerfile 1>&2 && @pause


:: -----------------------------------------------------------------
:: --- Run the container
:: -----------------------------------------------------------------
echo Running new instance of %NAME%
docker run -d --rm --name %NAME% "%NAME%"
if %ERRORLEVEL% NEQ 0 echo Error running new instance of %NAME% 1>&2 && @pause


:: -----------------------------------------------------------------
:: --- Make sure the container is actually running
:: -----------------------------------------------------------------
echo Waiting 10 seconds for container to initalize
timeout /t 10

FOR /F "tokens=* USEBACKQ" %%F IN (`docker ps --filter name^=^^%NAME%$ -q`) DO (
set "result=%%F")
IF "%result%" == "" echo Container appears to have stopped running, possible error during initialization 1>&2 && @pause
IF NOT "%result%" == "" echo Container appears to be still running after initialization
:end

:: -----------------------------------------------------------------
:: --- Keep window open for review
:: -----------------------------------------------------------------
@pause
