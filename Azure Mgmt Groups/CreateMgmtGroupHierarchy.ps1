<# A script used to deploy a management group tree hierarchy via Azure CloudShell

Created:        31/07/2020
Updated:        24/02/2021
Authors:        Wim Matthyssen; Jonathan Vella
PowerShell:     PowerShell 5.1; Azure PowerShell
Version:        Install latest Az modules
Action:         Change variables where needed to fit your needs
Disclaimer:     This script is provided "As IS" with no warranties.
Ref:            https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/management-group-and-subscription-organization

.EXAMPLE

.\CreateManagementGroupHierarchy.ps1

#>

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Define Variables

# Level-1 Management Group
$customerName ="ilc"
$ManagementGroupName = "mg-" + $customerName
$ManagementGroupGuid = New-Guid

# Level-2 Platform Management Group
$platform = "Platform"
$platformManagementGroupName = $ManagementGroupName + "-" + $platform
$platformManagementGroupGuid = New-Guid

# Level-3 Platform Management Groups
$mgmt = "Management"
$connect = "Connectivity"
$identity = "Identity"
$mgmtManagementGroupName = $ManagementGroupName + "-" + $mgmt
$mgmtManagementGroupGuid = New-Guid
$connectManagementGroupName = $ManagementGroupName + "-" + $connect
$connectManagementGroupGuid = New-Guid
$identityManagementGroupName = $ManagementGroupName + "-" + $identity
$identityManagementGroupGuid = New-Guid

# Level-2 Landing Zones Management Group
$lz = "LandingZones"
$lzManagementGroupName = $ManagementGroupName + "-" + $lz
$lzManagementGroupGuid = New-Guid

# Level-3 Landing Zones Management Groups
$prod = "Production"
$dev = "Dev"
$sandbox = "Sandbox"
$retired = "Retired"
$hybrid = "Hybrid"
$prodManagementGroupName = $ManagementGroupName + "-" + $prod
$prodManagementGroupGuid = New-Guid
$devManagementGroupName = $ManagementGroupName + "-" + $dev
$devManagementGroupGuid = New-Guid
$sandboxManagementGroupName = $ManagementGroupName + "-" + $sandbox
$sandboxManagementGroupGuid = New-Guid
$retiredManagementGroupName = $ManagementGroupName + "-" + $retired
$retiredManagementGroupGuid = New-Guid
$hybridManagementGroupName = $ManagementGroupName + "-" + $hybrid
$hybridManagementGroupGuid = New-Guid

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create Level-1 Management Group

New-AzManagementGroup -GroupName $ManagementGroupGuid -DisplayName $ManagementGroupName
$ManagementParentGroup = Get-AzManagementGroup -GroupName $ManagementGroupGuid

Write-Host ($writeEmptyLine + "*****Level-1 Management Group created*****") -foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create Level-2 Platform Management Group

New-AzManagementGroup -GroupName $PlatformManagementGroupGuid -DisplayName $PlatformManagementGroupName -ParentObject $ManagementParentGroup
$PlatformManagementParentGroup = Get-AzManagementGroup -GroupName $PlatformManagementGroupGuid

Write-Host ($writeEmptyLine + "*****Level-2 Platform Management Group created*****") -foregroundcolor $foregroundColor1 $writeEmptyLine

## Create Level-3 Platform Management Groups

New-AzManagementGroup -GroupName $mgmtManagementGroupGuid -DisplayName $mgmtManagementGroupName -ParentObject $PlatformManagementParentGroup
New-AzManagementGroup -GroupName $connectManagementGroupGuid -DisplayName $connectManagementGroupName -ParentObject $PlatformManagementParentGroup
New-AzManagementGroup -GroupName $identityManagementGroupGuid -DisplayName $identityManagementGroupName -ParentObject $PlatformManagementParentGroup

Write-Host ($writeEmptyLine + "*****Level-3 Platform Management Groups created*****") -foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create Level-2 Landing Zones Management Group

New-AzManagementGroup -GroupName $lzManagementGroupGuid -DisplayName $lzManagementGroupName -ParentObject $ManagementParentGroup
$lzManagementParentGroup = Get-AzManagementGroup -GroupName $lzManagementGroupGuid

Write-Host ($writeEmptyLine + "*****Level-2 Landing Zones Management Group created*****") -foregroundcolor $foregroundColor1 $writeEmptyLine

## Create Level-3 Landing Zones Management Groups

New-AzManagementGroup -GroupName $prodManagementGroupGuid -DisplayName $prodManagementGroupName -ParentObject $lzManagementParentGroup
New-AzManagementGroup -GroupName $devManagementGroupGuid -DisplayName $devManagementGroupName -ParentObject $lzManagementParentGroup
New-AzManagementGroup -GroupName $sandboxManagementGroupGuid -DisplayName $sandboxManagementGroupName -ParentObject $lzManagementParentGroup
New-AzManagementGroup -GroupName $retiredManagementGroupGuid -DisplayName $retiredManagementGroupName -ParentObject $lzManagementParentGroup
New-AzManagementGroup -GroupName $hybridManagementGroupGuid -DisplayName $hybridManagementGroupName -ParentObject $lzManagementParentGroup

Write-Host ($writeEmptyLine + "*****Level-3 Landing Zones Management Groups created*****") -foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
