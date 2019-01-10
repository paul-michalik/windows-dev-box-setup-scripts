# Description: Boxstarter Script
# Author: Paul Michalik
# Common dev settings for desktop app development

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
# Show hidden files, Show protected OS files, Show file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
Enable-WindowsOptionalFeature -Online -FeatureName containers -All
RefreshEnv
choco install -y Microsoft-Hyper-V-All --source="'windowsFeatures'"
RefreshEnv

#--- Tools ---
choco install -y cmake.install --install-arguments='ADD_CMAKE_TO_PATH=System'
choco install -y git.install --package-parameters="/NoShellIntegration /GitOnlyOnPath /WindowsTerminal /SChannel"
choco install -y tortoisegit
choco install -y chocolateygui
choco install -y previewconfig
choco install -y winmerge 
choco install -y docker-for-windows

#--- Installing VS and VS Code with Git
# See this for install args: https://chocolatey.org/packages/VisualStudio2017Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids
# visualstudio2017community
# visualstudio2017professional
# visualstudio2017enterprise

choco install -y visualstudio2017community --package-parameters="'--add Microsoft.VisualStudio.Component.Git'"
Update-SessionEnvironment #refreshing env due to Git install

#--- UWP Workload and installing Windows Template Studio ---
#choco install -y visualstudio2017-workload-azure
#choco install -y visualstudio2017-workload-universal
#choco install -y visualstudio2017-workload-manageddesktop
#choco install -y visualstudio2017-workload-nativedesktop

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
