$Last_n_Hours = [DateTime]::Now.AddHours(-2)
$badRDPlogons = Get-EventLog -LogName 'Security' -after $Last_n_Hours -InstanceId 4625 | Select-Object @{n='IpAddress';e={$_.ReplacementStrings[-2]} }
$getip = $badRDPlogons | group-object -property IpAddress | where {$_.Count -gt 2} | Select -property Name
$log = "C:\blockedrdp\rdp_blocked_ip.txt"
$current_ips = (Get-NetFirewallRule -DisplayName "BlockRDPBruteForce" | Get-NetFirewallAddressFilter ).RemoteAddress | Sort-Object | Get-Unique
foreach ($ip in $getip){
  if (-not ($current_ips -match $ip.name)) {
    $current_ips = $current_ips + $ip.name
    (Get-Date).ToString() + ' ' + $ip.name + ' The IP address has been blocked due to ' + ($badRDPlogons | where {$_.IpAddress -eq $ip.name}).count + ' attempts for 2 hours'>> $log
  }
}
Set-NetFirewallRule -DisplayName "BlockRDPBruteForce" -RemoteAddress $current_ips -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Block
