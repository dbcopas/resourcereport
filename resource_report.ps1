# Ensure you have the required modules installed
if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    Install-Module -Name Az.Accounts -Force -Scope CurrentUser
}

if (-not (Get-Module -ListAvailable -Name Az.Resources)) {
    Install-Module -Name Az.Resources -Force -Scope CurrentUser
}

# Connect to Azure
Connect-AzAccount

# (optional) Get all subscriptions seen by this account
# $subscriptions = Get-AzSubscription

# (optional) Work with these subcriptions only
$subscriptions = @(
    [PSCustomObject]@{ Id = '[subid]' },
    [PSCustomObject]@{ Id = '[subid]' },
    [PSCustomObject]@{ Id = '[subid]' }
)

# Initialize an array to hold all resources
$allResources = @()

# Iterate through each subscription
foreach ($subscription in $subscriptions) {
    # Set the current context to the subscription
    Set-AzContext -SubscriptionId $subscription.Id

    # Get all resources in the current subscription
    $resources = Get-AzResource

    # Add the resources to the allResources array
    $allResources += $resources
}


# Output all resources with detailed information and Defender suitability
$report = $allResources | ForEach-Object {
    [PSCustomObject]@{
        Name              = $_.Name
        ResourceType      = $_.ResourceType
        Location          = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        SubscriptionId    = $_.SubscriptionId

    }
}

# Display the report
$report | Format-Table -AutoSize

# Optionally, export the report to a CSV file
$report | Export-Csv -Path "output.csv" -NoTypeInformation
