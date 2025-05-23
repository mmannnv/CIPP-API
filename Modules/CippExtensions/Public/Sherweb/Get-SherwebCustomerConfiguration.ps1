function Get-SherwebCustomerConfiguration {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CustomerId,
        [string]$TenantFilter
    )
    if ($TenantFilter) {
        $TenantFilter = (Get-Tenants -TenantFilter $TenantFilter).customerId
        $CustomerId = Get-ExtensionMapping -Extension 'Sherweb' | Where-Object { $_.RowKey -eq $TenantFilter } | Select-Object -ExpandProperty IntegrationId
    }
    $AuthHeader = Get-SherwebAuthentication
    $Uri = "https://api.sherweb.com/service-provider/v1/customers/$($CustomerId)/platforms-configurations/"
    $CustomerConfig = Invoke-RestMethod -Uri $Uri -Method GET -Headers $AuthHeader
    $customerPlatforms = foreach ($Config in $CustomerConfig.configuredPlatforms) {
        #https://api.sherweb.com/service-provider/v1/customers/{customerId}/platforms/{platformId}/details
        $Uri = "https://api.sherweb.com/service-provider/v1/customers/$($CustomerId)/platforms/$($Config.id)/details"
        Invoke-RestMethod -Uri $Uri -Method GET -Headers $AuthHeader
    }
    return $customerPlatforms

}
