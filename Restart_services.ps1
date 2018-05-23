# For single, dependent service with force flag
Get-Service -ComputerName NGSVCS2 -ServiceName NGDB.NGProd.1.RosettaService

Get-Service -Name MSSQLSERVER -ComputerName CSHSTESTDB3_2 | Restart-Service -Force

#For multiple Services in Multiple servers using arrays
$Machines = @(
 'CSHSTESTDB3_2'
)

$Services = @(
    'MSSQLSERVER'
)

foreach ($service in $services){
    foreach ($Machine in $Machines){
        Get-Service -Name $service -ComputerName $Machine | Restart-Service -Force -PassThru
    }
}


# Or read service and machines from txt files
$Services = Get-Content -Path "U:\GitLab\HelpDesk\Scripts\LNL\Week_8\Services.txt"
$Machines = Get-Content -Path "U:\GitLab\HelpDesk\Scripts\LNL\Week_8\Machines.txt"

foreach ($service in $services){
    foreach ($Machine in $Machines){
        Get-Service -Name $service -ComputerName $Machine | Restart-Service -Force -PassThru
    }
}

#Or using single line argument
Get-Content .\services.txt | %{Get-WmiObject -Class Win32_Service -ComputerName (Get-Content .\Machines.txt) -Filter "Name='$_'"} | %{$_.StopService()}; 
Get-Content .\services.txt | %{Get-WmiObject -Class Win32_Service -ComputerName (Get-Content .\Machines.txt) -Filter "Name='$_'"} | %{$_.StartService()}





