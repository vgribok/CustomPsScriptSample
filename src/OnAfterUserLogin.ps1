<#

Feel free to modify this file by implementing your logic.

This script is invoked by Windows "shell:startup". It runs
under Administrator interactive user in minimized window to
minimize changes that users will close the window before 
script finishes its run.

This script needs to complete its run fast to avoid
distracting users. A few seconds is ideal.

#>
[CmdletBinding()]
param (
    [Parameter()] [String] $RdsInstanceName = "rds-sql-server",
    [Parameter()] [String] $RdsSecretPrefix = "RdsCredentials-"
)

Write-Host "Windows user `"$($env:USERNAME)`" logged in at $(Get-Date)."

Write-Host "Creating ASP.NET Membership SQL Server database locally"
& $env:WINDIR\Microsoft.Net\Framework\v4.0.30319\aspnet_regsql.exe -S . -d Identity -A all -E

Write-Host -NoNewline "Importing AWS PowerShell module.."
Import-Module AWSPowerShell.NetCore
Write-Host "Done"

$rdsInstance = Get-RDSDBInstance $RdsInstanceName
$rdsEndpoint = $rdsInstance.Endpoint.Address

$rdsCredSecret = Get-SECSecretList | where { $_.Name.StartsWith($RdsSecretPrefix) }
$rdsSecret = (Get-SECSecretValue $rdsCredSecret.Name).SecretString | ConvertFrom-Json

# $rdsEndpoint
# $rdsInstance.MasterUsername
# $rdsSecret.Password

"Data Source=$rdsEndpoint; Initial Catalog=MusicStore; User Id=$($rdsInstance.MasterUsername); Password=$($rdsSecret.Password)" | Out-File C:\MusicStoreDbString.txt
"Data Source=$rdsEndpoint; Initial Catalog=Identity; User Id=$($rdsInstance.MasterUsername); Password=$($rdsSecret.Password)" | Out-File C:\IdentityDbString.txt

Write-Host "Initializing ASP.NET Membership database on RDS"
& $env:WINDIR\Microsoft.Net\Framework\v4.0.30319\aspnet_regsql.exe -d Identity -S $rdsEndpoint -U $rdsInstance.MasterUsername -P $rdsSecret.Password -A all

