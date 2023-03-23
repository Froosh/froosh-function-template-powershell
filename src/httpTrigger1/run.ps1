#Requires -Version 7.2

using namespace System.Net

[CmdletBinding(PositionalBinding = $false)]

# Input bindings are passed in via param block.
Param (
  [Microsoft.Azure.Functions.PowerShellWorker.HttpRequestContext]
  $Request,

  [hashtable]
  $TriggerMetadata
)

Set-StrictMode -Version Latest
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

Write-Information -MessageData ('Request Type: {0}' -f $Request.GetType())
Write-Information -MessageData ('Request: {0}' -f (ConvertTo-Json -InputObject $Request))

Write-Information -MessageData ('TriggerMetadata Type: {0}' -f $TriggerMetadata.GetType())
Write-Information -MessageData ('TriggerMetadata: {0}' -f (ConvertTo-Json -InputObject $TriggerMetadata))

# Interact with query parameters or the body of the request.
if ($Request.Query -and $Request.Query.ContainsKey('Name')) {
  $Name = $Request.Query['Name']
} elseif ($Request.Body -and $Request.Body.ContainsKey('Name')) {
  $Name = $Request.Body['Name']
} else {
  $Name = $null
}

if ($Name) {
  $Body = "Hello, $name. This HTTP triggered function executed successfully."
} else {
  $Body = 'This HTTP triggered function executed successfully. Pass "name" in the query string or in the request body for a personalized response.'
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext] @{
    StatusCode = [HttpStatusCode]::OK
    Body       = $Body
  })
