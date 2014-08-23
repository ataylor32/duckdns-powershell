#Requires -Version 2

<#
.SYNOPSIS
	Updates the IP address of your Duck DNS domain(s).
.DESCRIPTION
	Updates the IP address of your Duck DNS domain(s). Intended to be run as a
	scheduled task.
.PARAMETER Domains
	A comma-separated list of your Duck DNS domains to update.
.PARAMETER Token
	Your Duck DNS token.
.PARAMETER IP
	The IP address to use. If you leave it blank, Duck DNS will detect your
	gateway IP.
.INPUTS
	None. You cannot pipe objects to this script.
.OUTPUTS
	None. This script does not generate any output.
.EXAMPLE
	.\Update-DuckDNS.ps1 -Domains "foo,bar" -Token my-duck-dns-token
.LINK
	https://github.com/ataylor32/duckdns-powershell
#>

Param (
	[Parameter(
		Mandatory=$True,
		HelpMessage="Comma separate the domains if you want to update more than one."
	)]
	[ValidateNotNullOrEmpty()]
	[String]$Domains,

	[Parameter(Mandatory=$True)]
	[ValidateNotNullOrEmpty()]
	[String]$Token,

	[String]$IP
)

$URL = "https://www.duckdns.org/update?domains={0}&token={1}&ip={2}" -F $Domains, $Token, $IP

Write-Debug "`$URL set to $URL"

Write-Verbose "Sending update request to Duck DNS..."

If ($PSVersionTable.PSVersion.Major -Gt 2) {
	$Result = Invoke-WebRequest $URL

	If ($Result -Ne $Null) {
		$ResponseString = $Result.ToString()
	}
}
Else {
	$Request = [System.Net.WebRequest]::Create($URL)
	$Response = $Request.GetResponse()

	If ($Response -Ne $Null) {
		$StreamReader = New-Object System.IO.StreamReader $Response.GetResponseStream()
		$ResponseString = $StreamReader.ReadToEnd()
	}
}

If ($ResponseString -Eq "OK") {
	Write-Verbose "Update successful."
}
ElseIf ($ResponseString -Eq "KO") {
	Write-Error "Update failed."
}
