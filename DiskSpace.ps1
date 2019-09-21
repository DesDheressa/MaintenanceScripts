# Issue warning if % free disk space is less 
$PercentWarning = 30;
$ServerDisk = 'C:\Users\cwf87797\Box\My Box Notes\ServerDisk.csv'
#$ServerDir = '\\cherryhealth.net\users\desdheressa\Documents\Information System\PowerShell'
$ServerList = 'C:\Users\cwf87797\Box\My Box Notes\serverlist.txt'
# Path of files
#$path = '\\cherryhealth\users\desDheressa\Documents\Information System\PowerShell'
#First loop
#$FLoop = 0;

#SQL snap-ins
#Add-pssnapin SqlServerCmdletSnapin100
#Add-pssnapin SqlServerProviderSnapin100
Import-Module sqlps -DisableNameChecking
#Set-Location c:

# Remove Server Disk File
If (Test-Path $ServerDisk)
{
    Remove-Item $ServerDisk
}

$servers = Get-Content $serverlist;
$datetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss";

# Add headers to log files
Add-Content $ServerDisk "ServerName,DriveLetter,SnapshotDate,DriveCapacity,SpaceUsed,SpaceFree,ServerGroup";

Import-Csv $serverlist |
ForEach-Object{
    $Name = $_.ServerName
    $Group = $_.ServerGroup
    Write-Host $Name " ," $Group
    
    # Get fixed drive info
	$disks = Get-WmiObject -ComputerName $Name -Class Win32_LogicalDisk -Filter "DriveType = 3";
 
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

# Add CSV data to table
# Invoke-Sqlcmd -Database DbMaintenance -Query "Exec dbo.dbaGetDiskDriveUsage" -ServerInstance SqlMonitor