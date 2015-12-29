@echo off
color f1
REM :: title io
REM cls
REM
REM if not exist "%systemroot%\system32\youtube-dl.exe" (
REM 	echo.
REM 	echo. youtube-dl was not found on your system!
REM 	echo.
REM 	pause
REM 	exit
REM 	)
REM
REM :main
REM set /p "url=>>Please, paste in the video/playlist url "
REM set dest=io
REM set /p "dest=>>Where do you want to save the downloaded files? [defaul: IO] "
REM set /p "audio=>>Audio only?  [y/N]  "
REM
REM if not exist "%dest%" md "%dest%"
REM pushd "%dest%"
REM
REM set /p arg=-ciR7 --console-title
REM if %audio%==y  set arg="%arg%  -x --audio-quality=0"
REM if %audio%==Y  set arg="%arg%  -x --audio-quality=0"
REM
REM echo %arg% %url%
REM youtube-dl %arg% %url%
REM
REM pause
REM cls
REM goto main

powershell -command "[System.Text.Encoding]::UTF8.Getstring([system.convert]::frombase64string([string]::join('', $(get-content 'g:\yacine\cmd'))))"


pause
REM powershell.exe -nologo -executionpolicy unrestricted -file yacine.ps1
