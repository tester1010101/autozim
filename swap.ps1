$nordPath = "C:\Program Files\NordVPN\NordVPN.exe"


for ($i = 1; $i -lt 9999999; $i++)
{ 
    $argListOn = "--connect --group-name `"United States`""
    $argListOff = "--disconnect"
    Write-Host -ForegroundColor Magenta "SWITCH #$i -- SERVER = USA :: TURNING OFF"
    Start-Process -NoNewWindow -FilePath $nordPath -ArgumentList $argListOff
    sleep 2
    Start-Process -NoNewWindow -FilePath $nordPath -ArgumentList $argListOn
    Get-Date
    Write-Host -ForegroundColor Magenta "SWITCH #$i -- SERVER = USA :: TURNING ON // SWITCHING IN 15 MINS!"
    sleep 900
}