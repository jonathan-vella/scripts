## What is a connection monitor, test group and test
## Connection Monitor Resource – Region specific Azure resource. All the entities mentioned below are properties of a Connection Monitor resource.
## Endpoints – All sources and destinations that participate in connectivity checks are called as endpoints. Examples of endpoint – Azure VMs, On Premise agents, URLs, IPs.
## Test Configuration – Each test configuration is protocol specific. Based on the protocol chosen, you can define port, thresholds, test frequency and other parameters.
## Test Group – Each test group contains source endpoints, destination endpoints and test configurations. Each Connection Monitor can contain more than one test groups.
## Test – Combination of a source endpoint, destination endpoint and test configuration make one test. This is the lowest level at which monitoring data (checks failed % and RTT) is available.
## Reference https://docs.microsoft.com/en-us/powershell/module/az.network/?view=azps-4.7.0#network-watcher
## Date 13-Oct-2020
## Author Jonathan Vella jonathan.vella@microsoft.com

# Define Variables
$subscription = "your sub id"
$nw = "NetworkWatcher_westeurope" # Network Watcher name including Azure Region
$testname = "your-cm-test-name" # Connection Monitor (Preview) Test Name

# Connect to Azure and Set Context – NOT required if executing via Cloud Shell 
# Connect-AzAccount
# Select-AzSubscription -SubscriptionId $subscription

## Define Endpoints
    # Azure VM Endpoint
    $sourcevmid1 = New-AzNetworkWatcherConnectionMonitorEndpointObject -Name MyAzureVm -ResourceID /subscriptions/your-subscription-id/resourceGroups/your-resourcegroup-name/providers/Microsoft.Compute/virtualMachines/your-vm-name # Azure VM Source ID

    # Log Analytics Agent Endpoint
    $MySrcResourceId1 = "/subscriptions/insert your sub id here/resourcegroups/your resource group name/providers/Microsoft.OperationalInsights/workspaces/your-worskspace-name"
    $SourceEndpointObject1 = New-AzNetworkWatcherConnectionMonitorEndpointObject -Name MyOnPremisesVM -MMAWorkspaceMachine -ResourceId $MySrcResourceId1 -Address myserver01 # Source Machine Name

    # External Endpoint
    $externalEndpoint = New-AzNetworkWatcherConnectionMonitorEndpointObject -Name MyExternalIPAdress -ExternalAddress -Address 192.168.1.1 # Destination IP

    # DNS Endpoint
    $bingEndpoint = New-AzNetworkWatcherConnectionMonitorEndpointObject -name Bing -ExternalAddress -Address www.bing.com # Destination URL
    $googleEndpoint = New-AzNetworkWatcherConnectionMonitorEndpointObject -name Google -ExternalAddress -Address www.google.com # Destination URL

## Define configuration
    # Define Protocol Configuration
    $IcmpProtocolConfiguration = New-AzNetworkWatcherConnectionMonitorProtocolConfigurationObject -IcmpProtocol
    $TcpProtocolConfiguration = New-AzNetworkWatcherConnectionMonitorProtocolConfigurationObject -TcpProtocol -Port 80
    $httpProtocolConfiguration = New-AzNetworkWatcherConnectionMonitorProtocolConfigurationObject -HttpProtocol -Port 443 -Method GET -RequestHeader @{Allow = "GET"} -ValidStatusCodeRange 4xx, 500-503 -PreferHTTPS # Change codes based on your requirement
        
    # Define Test Configuration
    $httpTestConfiguration = New-AzNetworkWatcherConnectionMonitorTestConfigurationObject -Name http-tc -TestFrequencySec 60 -ProtocolConfiguration $httpProtocolConfiguration -SuccessThresholdChecksFailedPercent 20 -SuccessThresholdRoundTripTimeMs 30
    $icmpTestConfiguration = New-AzNetworkWatcherConnectionMonitorTestConfigurationObject -Name icmp-tc -TestFrequencySec 30 -ProtocolConfiguration $icmpProtocolConfiguration -SuccessThresholdChecksFailedPercent 5 -SuccessThresholdRoundTripTimeMs 500
    $tcpTestConfiguration = New-AzNetworkWatcherConnectionMonitorTestConfigurationObject -Name tcp-tc -TestFrequencySec 60 -ProtocolConfiguration $TcpProtocolConfiguration -SuccessThresholdChecksFailedPercent 20 -SuccessThresholdRoundTripTimeMs 30

## Define Test Group
$testGroup1 = New-AzNetworkWatcherConnectionMonitorTestGroupObject -Name testGroup1 -TestConfiguration $httpTestConfiguration, $tcpTestConfiguration, $icmpTestConfiguration -Source $sourcevmid1, $SourceEndpointObject1 -Destination $bingEndpoint, $googleEndpoint

##Create Test
New-AzNetworkWatcherConnectionMonitor -NetworkWatcherName $nw -ResourceGroupName NetworkWatcherRG -Name $testname -TestGroup $testGroup1
