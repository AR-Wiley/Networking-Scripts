function Ping-Test {

    $BaseIP = "192.168.1."
    $range = 1..10
    $machines = @()

    forEach ($i in $range){

        $ip = "$baseIP$i"

        if(Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue) {
            $machines += $ip
        }

    }

    Write-Output "Machines that are currently online: "
    return $machines

}

Ping-Test