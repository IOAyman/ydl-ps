$bindir = "$env:USERPROFILE\.bin"
$ydl = @{}
$ydl["bin"] = "$bindir\.youtube-dl.exe"
$ydl["url"] = "https://yt-dl.org/downloads/latest/youtube-dl.exe"
$ydl["hash.alg"] = "sha256"
$ydl["hash.sum"] = "6b37a566e9f5726b1af5626c5ce912bbc5070502659e5017e83393f09a3670c9".ToUpper()
$ydl["cmd"] = @("-c", "-i", "-R7", "--ffmpeg-location=$bindir")
$ffmpg = @{}
$ffmpg["bin"] = @("ffmpeg.exe", "ffprobe.exe", "ffplay.exe")
$ffmpg["pkg"] = "$bindir\.ffmpgpkg.zip"
$ffmpg["url"] = "http://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-3.3.2-win64-static.zip"

function d {
  param([string]$u, [string]$to)
  try {
    $wc = New-Object system.net.webclient
    $wc.downloadfile($u, $to)
  } catch {
    write-host -background yellow -foreground red "Try to run as Administrator"
    exit
  }
}

if (-Not(test-path $bindir)){
  New-Item -Path $bindir -Force -ItemType Directory
  attrib +r +s +h $bindir
}
if (-Not(Test-Path $ydl["bin"])){
  write-host -foreground red "youtube-dl not found!"
  write-host -foreground red "Attempting to download ..."
  d $ydl["url"] $ydl["bin"]
  attrib +r +s +h $ydl["bin"]
}
$ffmpgmissing = $false
$ffmpg["bin"] | ForEach-Object {
  if (-Not(test-path $bindir"\"$_)){
    $ffmpgmissing = $true
    write-host -foreground red "some binaries are missing!"
    write-host -foreground red "will attempt to download them"
  }
}
if ($ffmpgmissing -eq $true) {
  if (-Not(test-path $ffmpg["pkg"])){
  write-host -foreground red "Downloading missing binaries ..."
    d $ffmpg["url"] $ffmpg["pkg"]
    attrib +r +s +h $ffmpg["pkg"]
  } else {
  write-host -foreground red "pkg found"
  }
  try {
  Add-Type -Assembly System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::OpenRead($ffmpg["pkg"]).Entries |
      where {$_.Name -like "*.exe"} |
      ForEach-Object {
        $f = $bindir+"\"+$_.Name
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $f, $true)
        attrib +r +s +h $f
      }
  } catch {
    write-host -foreground red "Couldn't extract pkg! PSVersion=$($PSVersionTable.PSVersion)"
    read-host
    exit
  }
}
 
write-host -foreground darkgreen "Using version $(&$ydl["bin"] --version)"
$url = read-host "Paste in the URL"
$audio = read-host "Download the audio files only? [y/N]"
$dest = read-host "Where to save?  [current directory by default] "

if (($dest.length > 0) -and (-not(test-path $dest))) {
  new-item -path $dest -force
} else {
  $dest = $pwd.path
}
pushd $dest

if ($audio -eq "y" -or $audio -eq "Y") {
  $ydl["cmd"]+=@("-x", "--audio-format=mp3", $url)
}
&$ydl["bin"] $ydl["cmd"]

write-host -foreground green "DONE!"
read-host
