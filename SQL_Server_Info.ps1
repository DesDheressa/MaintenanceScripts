
    
    $Servers = @(
        'CSHSTESTDB3_1', 
        'CSHSTESTDB3_2', 
        'NGTEST'
    )
    #import SQLPS module
Import-module SQLPS -DisableNameChecking;
    $Query = "SELECT SERVERPROPERTY('ServerName') AS ServerName
                ,SERVERPROPERTY('ProductVersion') AS ProductVersion
                ,SERVERPROPERTY('ProductLevel') AS ProductLevel
                ,SERVERPROPERTY('Edition') AS Edition
                ,SERVERPROPERTY('EngineEdition') AS EngineEdition;"
    $Servers | ForEach-Object{
$server = "$_";
Set-Location SQLSERVER:\SQL\$server Invoke-Sqlcmd -Query $Query -ServerInstance $server;
}
