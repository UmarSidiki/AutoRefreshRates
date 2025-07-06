Add-Type -AssemblyName System.Windows.Forms
$p = [System.Windows.Forms.SystemInformation]::PowerStatus.PowerLineStatus
if(-not(Get-Module DisplayConfig -ListAvailable)){Install-Module DisplayConfig -Scope CurrentUser -Force -AllowClobber | Out-Null}
Import-Module DisplayConfig -Force | Out-Null
Get-DisplayInfo|?{$_.Active}|%{
  $r = @(60,144)
  try{$r = (Get-DisplayMode -DisplayId $_.DisplayId).RefreshRate|sort -Unique}catch{try{$r = (Get-DisplayPath -DisplayId $_.DisplayId).RefreshRate|sort -Unique}catch{}}
  $t = if($p -eq 'Online'){($r|sort)[-1]}else{if($r -contains 60){60}else{($r|sort)[0]}}
  if($t){Set-DisplayRefreshRate -DisplayId $_.DisplayId -RefreshRate $t}
}