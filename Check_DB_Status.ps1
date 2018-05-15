# check if SQL module is already imported
Get-PSDrive

#import SQLPS module
import-module SQLPS -DisableNameChecking;

#find user database sizes across multi servers (assuming default sql instances)
'cshstestdb3_1', 'cshstestdb3_2', 'ngtest' | % { dir sqlserver:\sql\$_\default\databases } |  select parent, name, size | ogv -Title "Database Size(MB)";

#to write the above to a text outpu, run the following:
'cshstestdb3_1', 'cshstestdb3_2', 'ngtest' | % { dir sqlserver:\sql\$_\default\databases } |  select parent, name, size | out-file F:\DatabaseMaintenance\db_size.txt -append;

#check whether a specific login name is on which servers (assume default sql instances)
'cshstestdb3_1', 'cshstestdb3_2', 'ngtest' | % { dir sqlserver:\sql\$_\default\logins } | ? {$_.name -eq 'frontier'} |  select Parent, Name;

#check whether there is any non-simple recovery database which has not had a transaction log backup in the last 1 hour
'cshstestdb3_1', 'cshstestdb3_2', 'ngtest' | % {dir sqlserver:\sql\$_\default\databases} | ? {($_.RecoveryModel -ne 'Simple') -and ($_.lastlogbackupdate -lt (get-date).addhours(-1))} | select Parent, Name, LastLogbackupdate;

#find out the database user role membership 
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\databases\Dental\users | % -Begin {$a = @()} -process { $a += New-Object PSObject -property @{User = $_; Role = $_.EnumRoles()} } -end {$a} | select User, Role;

#find the last execution status of all SQL Server Agent Jobs on a SQL Server instance
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\jobserver\jobs | % {$_.enumhistory()} | group  jobname | % {$_.group[0]} | select  Server, JobName, RunDate, Message;

#find the current failed SQL Server Agent Jobs
dir SQLSERVER:\SQL\CSHSTESTDB3_1\DEFAULT\jobserver\jobs | % {$_.enumhistory()} | group  jobname | % {$_.group[0]} | ? {$_.RunStatus -eq 0}  |  select Server, JobName, Rundate, Message;

