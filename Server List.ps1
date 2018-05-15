﻿# Path of files
#$path = 'U:\"Information System"\"PowerShell"' 
$Path = "\\cherryhealth\users\desDheressa\Documents\Information System\PowerShell\ServerList.txt"

#Set-ExecutionPolicy Unrestricted
#Get-ExecutionPolicy -List

#SQL snap-ins
#Add-pssnapin SqlServerCmdletSnapin100
#Add-pssnapin SqlServerProviderSnapin100

# Remove Server List File
If (Test-Path $Path)
{
    Remove-Item $Path
}

# Add headers to log files
Add-Content $Path "ServerName,ServerGroup";

# Get server list
$ou = [ADSI]"LDAP://OU=SQL,OU=CSHS 2012 Servers,DC=cherryhealth,DC=net"
foreach ($child in $ou.psbase.Children )
{
   if ($child.ObjectCategory -like '*computer*')
    {
       $Name = $child.Name
      # Write-Host $Name
       if(Test-Connection -Cn $Name -BufferSize 16 -Count 1 -ea 0 -quiet)
           {Add-Content $Path "$Name,SQL";}
    }
}