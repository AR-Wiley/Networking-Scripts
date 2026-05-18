if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as Administrator."
    return 
} else {
    Write-Host "Running as Administrator."
}
 
$logDir = "$env:USERPROFILE\Desktop\Logs"
$logPath = Join-Path $logDir "pinginfo.csv"

$listPath = "$env:USERPROFILE\Desktop\list.txt"

$machines = @()

function Validate_Paths {

    if (-not(Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir 
    }

    if (-not(Test-Path $logPath)) {
        New-Item -ItemType File -Path $logPath 
    }

}

function Validate_List {

    if (-not(Test-Path $listPath)) {
        write-Host "List of IP Addresses does not exist!" -ForegroundColor Red 
    }
    
}

function Ping_Test {

    param(
        [Parameter(Mandatory = $true)]
        [string]$list = $listPath
    )

    forEach($i in (Get-Content $list)) {
        
        if(Test-Connection -ComputerName $i -Count 1 -Quiet -ErrorAction SilentlyContinue) {
            $machines += $i
        }
    }

    $machines |  Export-Csv -Path $logPath -NoTypeInformation -Append

}

Validate_Paths
Validate_List
Ping_Test
