Add-Type -AssemblyName System.Windows.Forms
$s = [System.Windows.Forms.SystemInformation]::PowerStatus.PowerLineStatus
$r = if ($s -eq 'Online') { 144 } elseif ($s -eq 'Offline') { 60 } else { $null }
if ($r) {
  if (-not (Get-Module DisplayConfig -ListAvailable)) {
    Install-Module DisplayConfig -Scope CurrentUser -Force -AllowClobber | Out-Null
  }
  Import-Module DisplayConfig -Force | Out-Null
  Get-DisplayInfo | Where Active | ForEach { Set-DisplayRefreshRate -DisplayId $_.DisplayId -RefreshRate $r }
}