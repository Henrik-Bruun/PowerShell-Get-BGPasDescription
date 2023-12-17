Function Get-BGPasDescription {
    <#
    .SYNOPSIS
        Extracts BGP AS Peer, Announcement, Country, Registry, Description. Using an external API.
    .DESCRIPTION
        This function extracts BGP information
        using https://www.team-cymru.com/ip-asn-mapping
    .PARAMETER asn
        The ASN (Autonomous System Number) to look up.
    .PARAMETER DNSserver
        The DNS server to use for the lookup.
    .EXAMPLE
        Get-BGPasDescription -asn '43557'
    .EXAMPLE
        Get-BGPasOrigin -ip '92.246.24.228' | Get-BGPasDescription
    .NOTES
        Author: Henrik Bruun  Github.com @Henrik-Bruun
        Version: 1.0 2023 December.
        Version: 0.9 2023 January - Not public.
    #>

    Param (
        [String]$asn = '43557',
        [String]$DNSserver = '1.1.1.1'
    )

    if ($asn -ne '') {
        $WHOIS = ".asn.cymru.com"
        $lookup = Resolve-DnsName -Server $DNSserver -Type TXT -Name "AS$asn$WHOIS" -ErrorAction SilentlyContinue

        $OriginAS = $lookup.Strings.Split('|')[0].Trim()
        $ASNCountryCode = $lookup.Strings.Split('`|')[1].Trim()
        $ASNRegistry = $lookup.Strings.Split('|')[2].Trim()
        $ASNAllocationDate = $lookup.Strings.Split('|')[3].Trim()
        $ASNDescription = $lookup.Strings.Split('|')[4].Trim()

        $data = [PSCustomObject]@{
            asn = $OriginAS
            asnCountryCode = $ASNCountryCode
            asnRegistry = $ASNRegistry
            asnAllocationDate = $ASNAllocationDate
            asnDescription = $ASNDescription
        }

        $data
    }
}

<#
# Example usage:
# Get-BGPasDescription -asn '43557'
# Get-BGPasOrigin -ip '92.246.24.228' | Get-BGPasDescription
# Get-AsDescription-Array -asn 43557
#>
