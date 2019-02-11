# check if SQL module is already imported
Get-PSDrive

#import SQLPS module
import-module SQLPS -DisableNameChecking;

$server = 'WSQ00863,50000'

#get the reason of last server shutdown/reboot (note: the local language should be English - US, otherwise, [Message] will not be displayed. This is a reported bug)
'NGTEST', 'CSHSTESTDB3_1', 'CSHSTESTDB3_2' | % {Get-WinEvent -ComputerName $_ -filterhashtable @{logname = 'System'; id = 1074; level = 4} -MaxEvents 1 } | select Message, TimeCreated | format-list;

#check when the multiple machines were last rebooted
gwmi -class win32_OperatingSystem -Computer $server | select @{label = 'Server'; e = {$_.PSComputerName}}, @{label = 'LastBootupTime'; e = {$_.converttodatetime($_.lastBootupTime)}};

# check the time on remote machine
$servers = 'NGUDS1', 'CSHSTESTDB3_1', 'CSHSTESTDB3_2'
ForEach ($server in $servers) {
    $time = ([WMI]'').ConvertToDateTime((gwmi win32_operatingsystem -computername $server).LocalDateTime)
    $server + '  ' + $time
}