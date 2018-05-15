# Take input from CSV and gather disk usage information

# Set variables for server CSV and Disk results CSV
$ServerDisk = '\\cherryhealth.net\users\desDheressa\Documents\Information System\PowerShell\ServerDisk.csv'
$ServerList = '\\cherryhealth.net\users\desDheressa\Documents\Information System\PowerShell\serverlist.txt'

# Remove Server Disk File
If (Test-Path $ServerDisk)
{
    Remove-Item $ServerDisk
}

$servers = Get-Content $serverlist;
$datetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss";

# Add headers to log files
Add-Content $ServerDisk "ServerName,DriveLetter,SnapshotDate,DriveCapacity,SpaceUsed,SpaceFree,ServerGroup";

$MyCredential = Get-Credential

Import-Csv $serverlist |
ForEach-Object{
    $Name = $_.ServerName
    $Group = $_.ServerGroup
    Write-Host $Name " ," $Group
    
        # Get fixed drive info
	    $disks = Get-WmiObject -Credential $MyCredential -Computername $Name -Class Win32_LogicalDisk -Filter "DriveType = 3";
 
	    foreach($disk in $disks)
	    {
		    $deviceID = $disk.DeviceID.substring(0,1);
		    [float]$size = $disk.Size;
		    [float]$freespace = $disk.FreeSpace;
 
		    $percentFree = [Math]::Round(($freespace / $size) * 100, 0);
		    $sizeMB = [Math]::Round($size / 1048576, 0);
		    $usedMB = [Math]::Round(($size - $freespace) / 1048576, 0);
            #$freeSpaceMB = [Math]::Round($freespace / 1048576, 0);
            $freeSpaceMB = $sizeMB - $usedMB;
		
		    Add-Content $ServerDisk "$Name,$deviceID,$datetime,$sizeMB,$usedMB,$freeSpaceMB,$Group";
	    }
}