# Copyright 2011-2012 Scott Banwart

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


if ($env:BTSINSTALLPATH) {
    Add-Type -Path "$env:BTSINSTALLPATH\Developer Tools\Microsoft.BizTalk.ExplorerOM.dll"
    Add-Type -Path "$env:BTSINSTALLPATH\Microsoft.BizTalk.ApplicationDeployment.Engine.dll"
    $btsCatalog = New-Object Microsoft.BizTalk.ExplorerOM.BTSCatalogExplorer
    $btsCatalog.ConnectionString = "Data Source=localhost;Initial Catalog=BizTalkMgmtDb;Integrated Security=SSPI"
}

function Add-Application([string]$appName, [string]$appDescription = "") {
    $app = $btsCatalog.AddNewApplication()
    $app.Name = $appName
    $app.Description = $appDescription
    $btsCatalog.SaveChanges()
}

function Remove-Application([string]$appName) {
    $app = $btsCatalog.Applications[$appName]
    
    if ($app)
    {
        Reset-Pipelines($app)
        Remove-Resources($app)
        $app = $btsCatalog.Applications[$appName]
        Remove-ReceivePorts($app)
        Remove-SendPortGroups($app)
        Remove-SendPorts($app)

        $btsCatalog.RemoveApplication($app)
        $btsCatalog.SaveChanges()
    }
}

function Add-ApplicationReference([string]$sourceAppName, [string]$destinationAppName) {
    $btsCatalog.Refresh()
    $sourceApp = $btsCatalog.Applications[$sourceAppName]
    $destinationApp = $btsCatalog.Applications[$destinationAppName]

    $destinationApp.AddReference($sourceApp)
    $btsCatalog.SaveChanges()
}

function Remove-ApplicationReference([string]$sourceAppName, [string]$destinationAppName) {
    $sourceApp = $btsCatalog.Applications[$sourceAppName]
    $destinationApp = $btsCatalog.Applications[$destinationAppName]

    $destinationApp.RemoveReference($sourceApp)
    $btsCatalog.SaveChanges()
}

function Start-Application([string]$appName)
{
    $btsCatalog.Refresh()
    $app = $btsCatalog.Applications[$appName]

    if ($app)
    {
        $app.Start([Microsoft.BizTalk.ExplorerOM.ApplicationStartOption]::StartAll)
    }
}

function Stop-Application([string]$appName)
{
    $btsCatalog.Refresh()
    $app = $btsCatalog.Applications[$appName]

    if ($app)
    {
        $app.Stop([Microsoft.BizTalk.ExplorerOM.ApplicationStopOption]::StopAll)
    }
}

function Restart-HostInstances([string[]]$hostInstances) {
    foreach ($hostInstance in $hostInstances) {
        Stop-HostInstance "$hostInstance"
        Start-HostInstance "$hostInstance"
    }
}

function Stop-HostInstance([string]$hostInstanceName) {
    Stop-Service "$hostInstanceName"
}

function Start-HostInstance([string]$hostInstanceName) {
    Start-Service "$hostInstanceName"
}

function ExportMsi([string]$appName, [string]$msiPath) {
    btstask.exe ExportApp -ApplicationName:"$appName" -Package:(Join-Path $msiPath "$appName.msi")
}

function Reset-Pipelines($app) {
    $defaultSendPipeline = "Microsoft.BizTalk.DefaultPipelines.XMLTransmit"
    $defaultReceivePipeline = "Microsoft.BizTalk.DefaultPipelines.XMLReceive"

    foreach ($port in $app.SendPorts) {
        $port.SendPipeline = $btsCatalog.Pipelines[$defaultSendPipeline]

        if ($port.ReceivePipeline) {
            $port.ReceivePipeline = $btsCatalog.Pipelines[$defaultReceivePipeline]
        }
    }

    foreach ($port in $app.ReceivePorts) {
        foreach ($location in $port.ReceiveLocations) {
            $location.ReceivePipeline = $btsCatalog.Pipelines[$defaultReceivePipeline]

            if ($location.SendPipeline) {
                $location.SendPipeline = $btsCatalog.Pipeline[$defaultSendPipeline]
            }
        }
    }
    $btsCatalog.SaveChanges()
}

#function Add-Resource($app) {
#    $group = New-Object Microsoft.BizTalk.ApplicationDeployment.Group
#    $group.DBName = "BizTalkMgmtDb"
#    $group.DBServer = "localhost"
#
#    $deployApp = $group.Applications[$app.Name]
#}

function Remove-Resources($app) {
    $group = New-Object Microsoft.BizTalk.ApplicationDeployment.Group
    $group.DBName = "BizTalkMgmtDb"
    $group.DBServer = "localhost"

    $deployApp = $group.Applications[$app.Name]
    $deployApp.RemoveResources($deployApp.ResourceCollection)
    
    $btsCatalog.Refresh()
    
    $group.Commit()
}

function Remove-ReceivePorts($app) {
    foreach ($port in $app.ReceivePorts) {
        $btsCatalog.RemoveReceivePort($port)
    }
    $btsCatalog.SaveChanges()
}

function Remove-SendPorts($app) {
    foreach ($port in $app.SendPorts) {
        $btsCatalog.RemoveSendPort($port)
    }
    $btsCatalog.SaveChanges()
}

function Remove-SendPortGroups($app) {
    foreach ($group in $app.SendPortGroups) {
        $btsCatalog.RemoveSendPortGroup($group)
    }
    $btsCatalog.SaveChanges()
}
