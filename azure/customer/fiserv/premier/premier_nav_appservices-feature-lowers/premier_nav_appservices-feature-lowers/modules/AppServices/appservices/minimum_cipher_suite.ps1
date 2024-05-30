[CmdletBinding()]

param
(
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [String]$ResourceGroupName,
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [String]$AppServiceName,
    [Parameter(ValuefromPipeline=$true,Mandatory=$false)] [String]$MinimumTlsCipherSuite
)

# Default Min Tls Cipher Suite value if overriden value not provided
if([string]::IsNullOrEmpty($MinimumTlsCipherSuite)){
    $MinimumTlsCipherSuite = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
}

$subscriptionId = $env:ARM_SUBSCRIPTION_ID
$tenantId = $env:ARM_TENANT_ID
$clientId = $env:ARM_CLIENT_ID
$secret = $env:ARM_CLIENT_SECRET

Write-Host "Connect Azure Account and set Azure Context"
$secureSecret = ConvertTo-SecureString -String $secret -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($clientId, $secureSecret)
Connect-AzAccount -Credential $Credential -Tenant $tenantId -ServicePrincipal
Set-AzContext -SubscriptionId $subscriptionId

$token = (Get-AzAccessToken).Token
$headers = @{Authorization="Bearer $token"}
$body = "{'properties':{'minTlsCipherSuite':'$MinimumTlsCipherSuite'}}"

$uri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Web/sites/$AppServiceName$TeamNumber/config/web?api-version=2022-03-01"
Invoke-WebRequest -Method PATCH -Headers $headers -ContentType "application/json" -Uri $uri -Body $body -UseBasicParsing
Write-Host "Completed updating Min TLS Cipher Suite."
