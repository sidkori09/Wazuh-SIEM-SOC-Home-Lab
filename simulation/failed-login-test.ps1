# Controlled failed-logon simulation for the Wazuh SOC home lab.
# Run only on a Windows system you own or are authorized to test.
# Prerequisite: local test account "wazuhlab" with a DIFFERENT real password.

$pw = ConvertTo-SecureString "WrongPass123!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\wazuhlab", $pw)

1..7 | ForEach-Object {
    Write-Host "Failed logon attempt $_"
    try {
        Start-Process "cmd.exe" -Credential $cred -WindowStyle Hidden -ErrorAction Stop
    }
    catch {
        Write-Host "Expected authentication failure"
    }
    Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host "Recent Event ID 4625 entries for wazuhlab:"
Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = 4625
    StartTime = (Get-Date).AddMinutes(-2)
} | Where-Object {
    $_.Message -match 'wazuhlab'
} | Select-Object TimeCreated, Id | Format-Table
