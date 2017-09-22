# Create a windows VM using powershell
# 

 param (
    [string]$username = "",
    [string]$password = ""
 )

$newVmName = "manualVmName"
$vmResourceGroupName = "SoftwareCiInfra"

$azureUsername = $username
$passwordString = $password

$vmNamePrefix = "tts-test"

Write-Output $azureUsername $passwordString

#Login to Azure
# TODO: It should be possible to use command line to create credentials and create VM
Import-Module AzureRM.profile
$azurePassword = ConvertTo-SecureString -String $passwordString -AsPlainText -Force
#$azurePassword = ConvertTo-SecureString -String $env:PASSWORD -AsPlainText -Force
$azureCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $azureUsername, $azurePassword
Login-AzureRmAccount -Credential $azureCredential

#Create networking resources

if ($newVmName -eq ""){
    
    Write-Output "no manual VM name given, find the first available and try to create."
    $vmNames = get-AzureRmVM -ResourceGroupName $vmResourceGroupName | Where-Object {$_.Name -like "$vmNamePrefix*"} | select-object {$_.Name}

    $existingNumberOfVms = $vmNames.Count
    $nextVM = $existingNumberOfVms + 1
    $newVmName = $vmNamePrefix + "$nextVM"

    $newVmName="tts-test2"
    Write-Output "$newVmName"

    
}

$vmAlreadyExists = get-AzureRmVM -ResourceGroupName $vmResourceGroupName | Where-Object {$_.Name -eq "$newVmName"}
    Write-Output "result $vmAlreadyExists"
    if($vmAlreadyExists -ne $null){
        Write-Output "$newVmName already exists, choose a different name" 
        exit 
    }

    Write-Output "CREATE a NEW VM $newVmName"


