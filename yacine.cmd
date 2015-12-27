@echo off
color fc
:: title io
cls

if not exist "%systemroot%\system32\youtube-dl.exe" (
	echo.
	echo. youtube-dl was not found on your system!
	echo.
	pause
	exit
	)

:main
set /p "url=>>Please, paste in the video/playlist url "
set dest=io
set /p "dest=>>Where do you want to save the downloaded files? [defaul: IO] "
set /p "audio=>>Audio only?  [y/N]  "

if not exist "%dest%" md "%dest%"
pushd "%dest%"

set /p arg=-ciR7 --console-title
if %audio%==y  set arg="%arg%  -x --audio-quality=0"
if %audio%==Y  set arg="%arg%  -x --audio-quality=0"

echo %arg% %url%
youtube-dl %arg% %url%

pause
cls
goto main
