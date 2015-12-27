#Rquires -RunAsAdministrator

$ydl = "$Env:windir\system32\youtube-dl.exe"
$ydlurl = "https://yt-dl.org/downloads/latest/youtube-dl.exe"


if (-Not(test-path $ydl)){
  write-host -foreground red "youtube-dl not found!"
  write-host -foreground red "Attempting to download ..."
  #if ( -Not (
  #  (
  #    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
  #  ).IsInRole( [Security.Principal.WindowsBuiltInRole] "Administrator" )
  #)) {
  #    write-host -background yellow -foreground red "You must be Administrator to install youtube-dl."
  #    exit-pssession
  #  }
  try {
    $wc = New-Object system.net.webclient
    $wc.downloadfile($ydlurl, $ydl)
  } catch {
    write-host -background yellow -foreground red "You must be Administrator to install youtube-dl."
    read-host
    exit-pssession
  }
}


write-host -foreground darkgreen "Using version $(youtube-dl --version)"
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
  youtube-dl -x $url
} else {
  youtube-dl $url
}

write-host -foreground green "DONE!"
read-host
