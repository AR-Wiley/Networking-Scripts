if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Write-Host "Please run this script as Administrator."
	return 
} else {
	Write-Host "Running as Administrator."
}

$logDir = "$env:USERPROFILE\Desktop\Logs"
$logPath = Join-Path $logDir "netinfo.csv"

$targets = @("CP1", "CP2")

function Validate-Logging {
	
	param(
		[string]$dir,
		[string]$path
    )
	
	if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir 
    }	
	
	if (!(Test-Path $path)) {
        New-Item -ItemType File -Path $path 
    }	
				
}

function Network-Information {

    param(
        [array]$computerName
    )
    
    $results = @()

    foreach ($i in $computerName) {

        $netInfo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=TRUE" -ComputerName $i

        foreach ($j in $netInfo) {

            $results += [PSCustomObject]@{
                ComputerName     = $i
                IPAddress        = $j.IPAddress -join ", "
                DHCPServer       = $j.DHCPServer
                DefaultIPGateway = $j.DefaultIPGateway -join ", "
                MACAddress       = $j.MACAddress
            }
        }
    } 

    $results | Export-Csv -Path $logPath -NoTypeInformation -Append

    return $results

}

Validate-Logging -dir $logDir -path $logPath
Network-Information -ComputerName $targets

