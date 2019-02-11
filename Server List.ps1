# Path of files
#$path = 'U:\"Information System"\"PowerShell"' 
$Path = "C:\Users\cwf87797\Box\My Box Notes\ServerList.txt"

#Set-ExecutionPolicy Unrestricted
#Get-ExecutionPolicy -List

#SQL snap-ins
#Add-pssnapin SqlServerCmdletSnapin100
#Add-pssnapin SqlServerProviderSnapin100

#Find the OU for the servers listed
#Remove the "CN" value as it is used only for local computer
([adsisearcher]"(&(name=$env:computername)(objectClass=computer))").findall().path


# Remove Server List File
If (Test-Path $Path)
{
    Remove-Item $Path
}

# Add headers to log files
Add-Content $Path "ServerName,ServerGroup";

# Get server list
$ou = [ADSI]"LDAP://OU=DBHDS,OU=Servers,OU=COV-Computers,DC=cov,DC=virginia,DC=gov"
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