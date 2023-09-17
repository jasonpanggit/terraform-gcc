Install-WindowsFeature -Name DNS -IncludeManagementTools
# add conditional forwarder
Add-DnsServerConditionalForwarderZone -Name $args[0] -MasterServers $args[1] -PassThru
