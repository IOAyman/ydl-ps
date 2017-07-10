$bindir = "$env:USERPROFILE\.bin"
$ydl = "$bindir\.youtube-dl.exe"
$ydlcmd = @("-c", "-i", "-R7", "--ffmpeg-location=$bindir")
$ydlurl = "https://yt-dl.org/downloads/latest/youtube-dl.exe"
$ffmpgbins = @('ffmpeg.exe', 'ffprobe.exe', 'ffplay.exe')
$ffmpgpkg = "$bindir\.ffmpgpkg.zip"
$ffmpgurl = "http://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-3.3.2-win64-static.zip"

function d {
  param([string]$u, [string]$to)
  try {
    $wc = New-Object system.net.webclient
    $wc.downloadfile($u, $to)
  } catch {
    write-host -background yellow -foreground red "Try to run as Administrator"
    exit-pssession
  }
}

if (-Not(test-path $bindir)){
  New-Item -Path $bindir -Force -ItemType Directory
  attrib +r +s +h $bindir
}
if (-Not(test-path $ydl)){
  write-host -foreground red "youtube-dl not found!"
  write-host -foreground red "Attempting to download ..."
  d $ydlurl $ydl
  attrib +r +s +h $ydl
}
$ffmpgmissing = $false
$ffmpgbins | ForEach-Object {
  if (-Not(test-path $bindir"\"$_)){
    $ffmpgmissing = $true
    write-host -foreground red "some binaries are missing!"
    write-host -foreground red "will attempt to download them"
  }
}
if ($ffmpgmissing -eq $true) {
  if (-Not(test-path $ffmpgpkg)){
	write-host -foreground red "Downloading missing binaries ..."
    d $ffmpgurl $ffmpgpkg
    attrib +r +s +h $ffmpgpkg
  } else {
	write-host -foreground red "pkg found"
  }
  Add-Type -Assembly System.IO.Compression.FileSystem
  [IO.Compression.ZipFile]::OpenRead($ffmpgpkg).Entries |
	where {$_.Name -like '*.exe'} |
	ForEach-Object {
	  $f = $bindir+"\"+$_.Name
	  [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $f, $true)
	  attrib +r +s +h $f
	}
}
 
write-host -foreground darkgreen "Using version $(&$ydl --version)"
$url = read-host "Paste in the URL"
$audio = read-host "Download the audio files only? [y/N]"
$dest = read-host "Where to save?  [current directory by default] "

if (($dest.length > 0) -and (-not(test-path $dest))) {
  new-item -path $dest -force
} else {
  $dest = $pwd.path
}
pushd $dest

if ($audio -eq 'y' -or $audio -eq 'Y') {
  $ydlcmd+=@("-x", "--audio-format=mp3", $url)
}
&$ydl $ydlcmd

write-host -foreground green "DONE!"
read-host
