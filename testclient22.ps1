param (
 [String]$HostName = "172.16.4.244",
 [Int]$Port = 22
)

try {
    $totalCount = 0
    $failureCount = 0

    while($true) {
      $tcpClient = New-Object System.Net.Sockets.TcpClient
      $beginConnect = $tcpClient.BeginConnect($HostName, $Port, $null, $null)

      # Wait for up to 1000 milliseconds for the connection to be established
      $connected = $beginConnect.AsyncWaitHandle.WaitOne(1000, $false)

      $totalCount++

      if ($connected) {
        Write-Output "[$(Get-Date -Format G)] Connection to $HostName on port $Port succeeded."
        $tcpClient.EndConnect($beginConnect)
      } else {
        Write-Output "[$(Get-Date -Format G)] Connection to $HostName on port $Port failed."
        $failureCount++
      }

      if($totalCount % 20 -eq 0) {
        $failedPercentage = ($failureCount / $totalCount) * 100
        Write-Output "[$(Get-Date -Format G)] Current Failed Connection Percentage is $failedPercentage%."
      }

      $tcpClient.Close()
      # Add a delay before the next loop iteration, if necessary
      Start-Sleep -Seconds 2
    }
}

finally {
    Write-Host "Terminated after testing $totalCount times"
    $failedPercentage = [math]::Round(($failureCount / $totalCount) * 100, 2)
    Write-Host "[$(Get-Date -Format G)] Final Failed Connection Percentage is $failedPercentage%."
}