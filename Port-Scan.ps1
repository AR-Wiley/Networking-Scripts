function Port-Scan {

    $BaseIP = "192.168.1."
    $range = 1..3
    $ports = @(21,22,23,80,139,3389,8080)
    $machines = @()

    forEach ($i in $range) {
        $ip = "$BaseIP$i"
        
        forEach ($j in $ports){
            $port_scan = Test-NetConnection $ip -Port $j
            
            if($port_scan.TcpTestSucceeded -eq $true){
                $machines += $port_scan
            }
        }
    }
    return $machines
}

