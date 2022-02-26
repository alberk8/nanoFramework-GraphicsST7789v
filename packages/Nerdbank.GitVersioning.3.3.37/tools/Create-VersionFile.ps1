<#
.SYNOPSIS
Generates a version.json file if one does not exist.
.DESCRIPTION
When creating version.json, AssemblyInfo.cs is loaded and the Major.Minor from the AssemblyVersion attribute is
used to seed the version number. Then, those Assembly attributes are removed from AssemblyInfo.cs. This cmdlet
returns the path to the generated file, or null if the file was not created (it already existed, or the cmdlet
was being executed with -WhatIf).
.PARAMETER ProjectDirectory
The directory of the project which is adding versioning logic with Nerdbank.GitVersioning.
.PARAMETER OutputDirectory
The directory where version.json should be generated. Defaults to the project directory if not specified.
This should either be the project directory, or in a parent directory of the project inside the repo.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
Param(
    [Parameter()]
    [string]$ProjectDirectory=".",
    [Parameter()]
    [string]$OutputDirectory=$null
)

$ProjectDirectory = Resolve-Path $ProjectDirectory
if (!$OutputDirectory)
{
    $OutputDirectory = $ProjectDirectory
}

$versionFileFound = $false
$SearchDirectory = $OutputDirectory
while (-not $versionFileFound -and $SearchDirectory) {
    $versionTxtPath = Join-Path $SearchDirectory "version.txt"
    $versionJsonPath = Join-Path $SearchDirectory "version.json"
    $versionFileFound = (Test-Path $versionTxtPath) -or (Test-Path $versionJsonPath)
    $SearchDirectory = Split-Path $SearchDirectory
}

if (-not $versionFileFound)
{
    $versionJsonPath = Join-Path $OutputDirectory "version.json"

    # The version file doesn't exist, which means this package is being installed for the first time.
    # 1) Load up the AssemblyInfo.cs file and grab the existing version declarations.
    # 2) Generate the version.txt with the version seeded from AssemblyInfo.cs
    # 3) Delete the version-related attributes in AssemblyInfo.cs

    $propertiesDirectory = Join-Path $ProjectDirectory "Properties"
    $assemblyInfo = Join-Path $propertiesDirectory "AssemblyInfo.cs"
    $version = $null
    if (Test-Path $assemblyInfo)
    {
        $fixedLines = (Get-Content $assemblyInfo) | ForEach-Object {
            if ($_ -match "^\w*\[assembly: AssemblyVersion\(""([0-9]+.[0-9]+|\*)(?:.(?:[0-9]+|\*)){0,2}""\)\]$")
            {
                # Grab the Major.Minor out of this file which will be injected into the version.txt
                $version = $matches[1]
            }

            # Remove attributes related to assembly versioning since those are generated on the fly during the build
            $_ -replace "^\[assembly: Assembly(?:File|Informational|)Version\(""[0-9]+(?:.(?:[0-9]+|\*)){1,3}""\)\]$"
        }

        if ($PSCmdlet.ShouldProcess($assemblyInfo, "Removing assembly attributes"))
        {
            $fixedLines | Set-Content $assemblyInfo -Encoding UTF8
        }

        if ($version)
        {
            if ($PSCmdlet.ShouldProcess($versionJsonPath, "Writing version.json file"))
            {
                "{
  `"`$schema`": `"https://raw.githubusercontent.com/dotnet/Nerdbank.GitVersioning/master/src/NerdBank.GitVersioning/version.schema.json`",
  `"version`": `"$version`"
}" | Set-Content $versionJsonPath
                $versionJsonPath
            }
        }
        else
        {
            # This is not a warning because the user is probably already consuming version.json from a parent directory as part of
            # a solution- or repo-level versioning scheme.
            Write-Verbose "Could not find an AssemblyVersion attribute in file '$assemblyInfo'. Skipping version.json generation."
        }
    }
    else
    {
        Write-Warning "Could not find an AssemblyInfo.cs file at '$assemblyInfo'. Skipping version.json generation."
    }
}

# SIG # Begin signature block
# MIIfwQYJKoZIhvcNAQcCoIIfsjCCH64CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC3phPVaUNjg68T
# 8f/9AlEl6fJizNedj+C6IxHGJH5zWqCCDfswggPFMIICraADAgECAhACrFwmagtA
# m48LefKuRiV3MA0GCSqGSIb3DQEBBQUAMGwxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xKzApBgNV
# BAMTIkRpZ2lDZXJ0IEhpZ2ggQXNzdXJhbmNlIEVWIFJvb3QgQ0EwHhcNMDYxMTEw
# MDAwMDAwWhcNMzExMTEwMDAwMDAwWjBsMQswCQYDVQQGEwJVUzEVMBMGA1UEChMM
# RGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSswKQYDVQQD
# EyJEaWdpQ2VydCBIaWdoIEFzc3VyYW5jZSBFViBSb290IENBMIIBIjANBgkqhkiG
# 9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxszlc+b71LvlLS0ypt/lgT/JzSVJtnEqw9WU
# NGeiChywX2mmQLHEt7KP0JikqUFZOtPclNY823Q4pErMTSWC90qlUxI47vNJbXGR
# fmO2q6Zfw6SE+E9iUb74xezbOJLjBuUIkQzEKEFV+8taiRV+ceg1v01yCT2+OjhQ
# W3cxG42zxyRFmqesbQAUWgS3uhPrUQqYQUEiTmVhh4FBUKZ5XIneGUpX1S7mXRxT
# LH6YzRoGFqRoc9A0BBNcoXHTWnxV215k4TeHMFYE5RG0KYAS8Xk5iKICEXwnZreI
# t3jyygqoOKsKZMK/Zl2VhMGhJR6HXRpQCyASzEG7bgtROLhLywIDAQABo2MwYTAO
# BgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUsT7DaQP4
# v0cB1JgmGggC72NkK8MwHwYDVR0jBBgwFoAUsT7DaQP4v0cB1JgmGggC72NkK8Mw
# DQYJKoZIhvcNAQEFBQADggEBABwaBpfc15yfPIhmBghXIdshR/gqZ6q/GDJ2QBBX
# wYrzetkRZY41+p78RbWe2UwxS7iR6EMsjrN4ztvjU3lx1uUhlAHaVYeaJGT2imbM
# 3pw3zag0sWmbI8ieeCIrcEPjVUcxYRnvWMWFL04w9qAxFiPI5+JlFjPLvxoboD34
# yl6LMYtgCIktDAZcUrfE+QqY0RVfnxK+fDZjOL1EpH/kJisKxJdpDemM4sAQV7jI
# dhKRVfJIadi8KgJbD0TUIDHb9LpwJl2QYJ68SxcJL7TLHkNoyQcnwdJc9+ohuWgS
# nDycv578gFybY83sR6olJ2egN/MAgn1U16n46S4To3foH0owggSRMIIDeaADAgEC
# AhAHsEGNpR4UjDMbvN63E4MjMA0GCSqGSIb3DQEBCwUAMGwxCzAJBgNVBAYTAlVT
# MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
# b20xKzApBgNVBAMTIkRpZ2lDZXJ0IEhpZ2ggQXNzdXJhbmNlIEVWIFJvb3QgQ0Ew
# HhcNMTgwNDI3MTI0MTU5WhcNMjgwNDI3MTI0MTU5WjBaMQswCQYDVQQGEwJVUzEY
# MBYGA1UEChMPLk5FVCBGb3VuZGF0aW9uMTEwLwYDVQQDEyguTkVUIEZvdW5kYXRp
# b24gUHJvamVjdHMgQ29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOC
# AQ8AMIIBCgKCAQEAwQqv4aI0CI20XeYqTTZmyoxsSQgcCBGQnXnufbuDLhAB6GoT
# NB7HuEhNSS8ftV+6yq8GztBzYAJ0lALdBjWypMfL451/84AO5ZiZB3V7MB2uxgWo
# cV1ekDduU9bm1Q48jmR4SVkLItC+oQO/FIA2SBudVZUvYKeCJS5Ri9ibV7La4oo7
# BJChFiP8uR+v3OU33dgm5BBhWmth4oTyq22zCfP3NO6gBWEIPFR5S+KcefUTYmn2
# o7IvhvxzJsMCrNH1bxhwOyMl+DQcdWiVPuJBKDOO/hAKIxBG4i6ryQYBaKdhDgaA
# NSCik0UgZasz8Qgl8n0A73+dISPumD8L/4mdywIDAQABo4IBPzCCATswHQYDVR0O
# BBYEFMtck66Im/5Db1ZQUgJtePys4bFaMB8GA1UdIwQYMBaAFLE+w2kD+L9HAdSY
# JhoIAu9jZCvDMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDAzAS
# BgNVHRMBAf8ECDAGAQH/AgEAMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEsGA1UdHwREMEIwQKA+oDyGOmh0dHA6
# Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEhpZ2hBc3N1cmFuY2VFVlJvb3RD
# QS5jcmwwPQYDVR0gBDYwNDAyBgRVHSAAMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8v
# d3d3LmRpZ2ljZXJ0LmNvbS9DUFMwDQYJKoZIhvcNAQELBQADggEBALNGxKTz6gq6
# clMF01GjC3RmJ/ZAoK1V7rwkqOkY3JDl++v1F4KrFWEzS8MbZsI/p4W31Eketazo
# Nxy23RT0zDsvJrwEC3R+/MRdkB7aTecsYmMeMHgtUrl3xEO3FubnQ0kKEU/HBCTd
# hR14GsQEccQQE6grFVlglrew+FzehWUu3SUQEp9t+iWpX/KfviDWx0H1azilMX15
# lzJUxK7kCzmflrk5jCOCjKqhOdGJoQqstmwP+07qXO18bcCzEC908P+TYkh0z9gV
# rlj7tyW9K9zPVPJZsLRaBp/QjMcH65o9Y1hD1uWtFQYmbEYkT1K9tuXHtQYx1Rpf
# /dC8Nbl4iukwggWZMIIEgaADAgECAhAFYpN4ggfGzI7e+5dJXBUHMA0GCSqGSIb3
# DQEBCwUAMFoxCzAJBgNVBAYTAlVTMRgwFgYDVQQKEw8uTkVUIEZvdW5kYXRpb24x
# MTAvBgNVBAMTKC5ORVQgRm91bmRhdGlvbiBQcm9qZWN0cyBDb2RlIFNpZ25pbmcg
# Q0EwHhcNMjAwMzA5MDAwMDAwWhcNMjMwMzE0MTIwMDAwWjCBlDEUMBIGA1UEBRML
# NjAzIDM4OSAwNjgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMSMwIQYDVQQKExpOZXJkYmFuayAoLk5FVCBGb3VuZGF0
# aW9uKTEjMCEGA1UEAxMaTmVyZGJhbmsgKC5ORVQgRm91bmRhdGlvbikwggEiMA0G
# CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDd8GcSai3H8uRYwQIFAYMsdy7Oq6/g
# SzYqthXiDQFCQVcXrwkIkjworfEDYInY357I1PZv9tsYmVbFgVwYSvltnErK0s2L
# o+FpuZJJsafrS9GlYs/TVzWLLxNAYZ/E1xQk0b5MJBLF0r1bTYfDTMbOTdE6VVdJ
# wFQ2Eom+Ua0M3B8c67T4BYFIkRi3mTauE6vL8ju2f3F+x45Y26WfuwxBlOxrNhUz
# EXfrfobKn5YWNxjDIHzT166HWFBObvPNU2aujcnHhqM7Rr9D7nLdW5EG9eZbQYKK
# xYxVoZvs+ogGYV4bJ4HmANdR8XriaxZIXpZJwkOL8wKXzyJ3wB8M3tbXAgMBAAGj
# ggIeMIICGjAfBgNVHSMEGDAWgBTLXJOuiJv+Q29WUFICbXj8rOGxWjAdBgNVHQ4E
# FgQUYn0uYWJ8GN7gASwIjfrRxqDt8qowNAYDVR0RBC0wK6ApBggrBgEFBQcIA6Ad
# MBsMGVVTLVdBU0hJTkdUT04tNjAzIDM4OSAwNjgwDgYDVR0PAQH/BAQDAgeAMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMIGZBgNVHR8EgZEwgY4wRaBDoEGGP2h0dHA6Ly9j
# cmwzLmRpZ2ljZXJ0LmNvbS9ORVRGb3VuZGF0aW9uUHJvamVjdHNDb2RlU2lnbmlu
# Z0NBLmNybDBFoEOgQYY/aHR0cDovL2NybDQuZGlnaWNlcnQuY29tL05FVEZvdW5k
# YXRpb25Qcm9qZWN0c0NvZGVTaWduaW5nQ0EuY3JsMEwGA1UdIARFMEMwNwYJYIZI
# AYb9bAMBMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9D
# UFMwCAYGZ4EMAQQBMIGEBggrBgEFBQcBAQR4MHYwJAYIKwYBBQUHMAGGGGh0dHA6
# Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBOBggrBgEFBQcwAoZCaHR0cDovL2NhY2VydHMu
# ZGlnaWNlcnQuY29tL05FVEZvdW5kYXRpb25Qcm9qZWN0c0NvZGVTaWduaW5nQ0Eu
# Y3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggEBABSznNfQBDO12zy8
# xbZQqbka9sJhw34Sr7GZnVC4Xw7iND49oAQaXihOhx0cKUeY4gNs3SxRVxpiI/OW
# s/zYy78flIP0QYMAZXCHM/s8ezQ+PlDRmZDe4GfLMVvC5mDYkaOPR9ac3afeg2cD
# WIb7QsSL1tSyiUKLvoVCBymp6rn/ZkllEpUM+dO4zdlgrv2GYzUxK8JO2Iokdv32
# 1Hq2tp5zYdjzX/yKxdCSUNRp24u6Xlgu1fy+KmUYYI7BFUmb9ZD1nG97oePQepti
# wRrRd8xaFbN5zMcnnls1lA/eSD8svGA/rhdB3TzN/oAGD9tJnz8crevBwHLN7ImQ
# IeujfFoxghEcMIIRGAIBATBuMFoxCzAJBgNVBAYTAlVTMRgwFgYDVQQKEw8uTkVU
# IEZvdW5kYXRpb24xMTAvBgNVBAMTKC5ORVQgRm91bmRhdGlvbiBQcm9qZWN0cyBD
# b2RlIFNpZ25pbmcgQ0ECEAVik3iCB8bMjt77l0lcFQcwDQYJYIZIAWUDBAIBBQCg
# gbQwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwG
# CisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIHL44ChTYpKy1qLEtK7DvHNOPJS3
# DUbsMebHLMh+CY2nMEgGCisGAQQBgjcCAQwxOjA4oAKAAKEygDBodHRwczovL2dp
# dGh1Yi5jb20vZG90bmV0L05lcmRiYW5rLkdpdFZlcnNpb25pbmcwDQYJKoZIhvcN
# AQEBBQAEggEAG0mOKiSifW0B4OJJTf9qbsBGwkDvmwTAHY0uI+se0V/Qd7/nebp/
# 3yi0y2roQIVEEqbFdaAkRZ2Xmt7vfmo5rHbxeuAvGg8afRFsQE87XPRgZED/WQfx
# 1vOQt/tooNeFuT8krmEzp0JaWh+rV4uNxSYMIz5HzidHa3UQUqYZV+5HNExjG7Y1
# p+I+kYEcc+JNwS24ALpgUCS/hpYRIOqc7S8genqgmRIabmQSh5gGPZVVZ5qe2tkT
# wVKt5oQQPk5amJP/G0QAbhao/geADcuTzo+55nqVCH84jq/F40p/cFGYkh8MLjjY
# T2U2sdU/G5HcdClR2FmJ+q7s4NxCcPFaOKGCDsgwgg7EBgorBgEEAYI3AwMBMYIO
# tDCCDrAGCSqGSIb3DQEHAqCCDqEwgg6dAgEDMQ8wDQYJYIZIAWUDBAIBBQAwdwYL
# KoZIhvcNAQkQAQSgaARmMGQCAQEGCWCGSAGG/WwHATAxMA0GCWCGSAFlAwQCAQUA
# BCDcA2kkUmnNcZzNhu8Z2W5g3W8baxWHHYTXLu81Yov3oQIQH6dIuNF12Fr8IXff
# FBumBRgPMjAyMDEwMDYyMDA2MTlaoIILuzCCBoIwggVqoAMCAQICEATNP4VornbG
# G7D+cWDMp20wDQYJKoZIhvcNAQELBQAwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoT
# DERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UE
# AxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQTAeFw0x
# OTEwMDEwMDAwMDBaFw0zMDEwMTcwMDAwMDBaMEwxCzAJBgNVBAYTAlVTMRcwFQYD
# VQQKEw5EaWdpQ2VydCwgSW5jLjEkMCIGA1UEAxMbVElNRVNUQU1QLVNIQTI1Ni0y
# MDE5LTEwLTE1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6WQ1nPqp
# mGVkG+QX3LgpNsxnCViFTTDgyf/lOzwRKFCvBzHiXQkYwvaJjGkIBCPgdy2dFeW4
# 6KFqjv/UrtJ6Fu/4QbUdOXXBzy+nrEV+lG2sAwGZPGI+fnr9RZcxtPq32UI+p1Wb
# 31pPWAKoMmkiE76Lgi3GmKtrm7TJ8mURDHQNsvAIlnTE6LJIoqEUpfj64YlwRDuN
# 7/uk9MO5vRQs6wwoJyWAqxBLFhJgC2kijE7NxtWyZVkh4HwsEo1wDo+KyuDT17M5
# d1DQQiwues6cZ3o4d1RA/0+VBCDU68jOhxQI/h2A3dDnK3jqvx9wxu5CFlM2RZtT
# GUlinXoCm5UUowIDAQABo4IDODCCAzQwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB
# /wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwggG/BgNVHSAEggG2MIIBsjCC
# AaEGCWCGSAGG/WwHATCCAZIwKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2lj
# ZXJ0LmNvbS9DUFMwggFkBggrBgEFBQcCAjCCAVYeggFSAEEAbgB5ACAAdQBzAGUA
# IABvAGYAIAB0AGgAaQBzACAAQwBlAHIAdABpAGYAaQBjAGEAdABlACAAYwBvAG4A
# cwB0AGkAdAB1AHQAZQBzACAAYQBjAGMAZQBwAHQAYQBuAGMAZQAgAG8AZgAgAHQA
# aABlACAARABpAGcAaQBDAGUAcgB0ACAAQwBQAC8AQwBQAFMAIABhAG4AZAAgAHQA
# aABlACAAUgBlAGwAeQBpAG4AZwAgAFAAYQByAHQAeQAgAEEAZwByAGUAZQBtAGUA
# bgB0ACAAdwBoAGkAYwBoACAAbABpAG0AaQB0ACAAbABpAGEAYgBpAGwAaQB0AHkA
# IABhAG4AZAAgAGEAcgBlACAAaQBuAGMAbwByAHAAbwByAGEAdABlAGQAIABoAGUA
# cgBlAGkAbgAgAGIAeQAgAHIAZQBmAGUAcgBlAG4AYwBlAC4wCwYJYIZIAYb9bAMV
# MB8GA1UdIwQYMBaAFPS24SAd/imu0uRhpbKiJbLIFzVuMB0GA1UdDgQWBBRWUw/B
# xgenTdfYbldygFBM5OyewTBxBgNVHR8EajBoMDKgMKAuhixodHRwOi8vY3JsMy5k
# aWdpY2VydC5jb20vc2hhMi1hc3N1cmVkLXRzLmNybDAyoDCgLoYsaHR0cDovL2Ny
# bDQuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC10cy5jcmwwgYUGCCsGAQUFBwEB
# BHkwdzAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME8GCCsG
# AQUFBzAChkNodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEy
# QXNzdXJlZElEVGltZXN0YW1waW5nQ0EuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQAu
# g6FEBUoE47kyUvrZgfAau/gJjSO5PdiSoeZGHEovbno8Y243F6Mav1gjskOclINO
# OQmwLOjH4eLM7ct5a87eIwFH7ZVUgeCAexKxrwKGqTpzav74n8GN0SGM5CmCw4oL
# YAACnR9HxJ+0CmhTf1oQpvgi5vhTkjFf2IKDLW0TQq6DwRBOpCT0R5zeDyJyd1x/
# T+k5mCtXkkTX726T2UPHBDNjUTdWnkcEEcOjWFQh2OKOVtdJP1f8Cp8jXnv0lI3d
# nRq733oqptJFplUMj/ZMivKWz4lG3DGykZCjXzMwYFX1/GswrKHt5EdOM55naii1
# TcLtW5eC+MupCGxTCbT3MIIFMTCCBBmgAwIBAgIQCqEl1tYyG35B5AXaNpfCFTAN
# BgkqhkiG9w0BAQsFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQg
# SW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2Vy
# dCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMTYwMTA3MTIwMDAwWhcNMzEwMTA3MTIw
# MDAwWjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgVGltZXN0YW1waW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
# MIIBCgKCAQEAvdAy7kvNj3/dqbqCmcU5VChXtiNKxA4HRTNREH3Q+X1NaH7ntqD0
# jbOI5Je/YyGQmL8TvFfTw+F+CNZqFAA49y4eO+7MpvYyWf5fZT/gm+vjRkcGGlV+
# Cyd+wKL1oODeIj8O/36V+/OjuiI+GKwR5PCZA207hXwJ0+5dyJoLVOOoCXFr4M8i
# EA91z3FyTgqt30A6XLdR4aF5FMZNJCMwXbzsPGBqrC8HzP3w6kfZiFBe/WZuVmEn
# KYmEUeaC50ZQ/ZQqLKfkdT66mA+Ef58xFNat1fJky3seBdCEGXIX8RcG7z3N1k3v
# BkL9olMqT4UdxB08r8/arBD13ays6Vb/kwIDAQABo4IBzjCCAcowHQYDVR0OBBYE
# FPS24SAd/imu0uRhpbKiJbLIFzVuMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
# IZ3zbcgPMBIGA1UdEwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMBMGA1Ud
# JQQMMAoGCCsGAQUFBwMIMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0
# cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNV
# HR8EejB4MDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRB
# c3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsMFAGA1UdIARJMEcwOAYKYIZI
# AYb9bAACBDAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20v
# Q1BTMAsGCWCGSAGG/WwHATANBgkqhkiG9w0BAQsFAAOCAQEAcZUS6VGHVmnN793a
# fKpjerN4zwY3QITvS4S/ys8DAv3Fp8MOIEIsr3fzKx8MIVoqtwU0HWqumfgnoma/
# Capg33akOpMP+LLR2HwZYuhegiUexLoceywh4tZbLBQ1QwRostt1AuByx5jWPGTl
# H0gQGF+JOGFNYkYkh2OMkVIsrymJ5Xgf1gsUpYDXEkdws3XVk4WTfraSZ/tTYYmo
# 9WuWwPRYaQ18yAGxuSh1t5ljhSKMYcp5lH5Z/IwP42+1ASa2bKXuh1Eh5Fhgm7oM
# LSttosR+u8QlK0cCCHxJrhO24XxCQijGGFbPQTS2Zl22dHv1VjMiLyI2skuiSpXY
# 9aaOUjGCAk0wggJJAgEBMIGGMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdp
# Q2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERp
# Z2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0ECEATNP4VornbG
# G7D+cWDMp20wDQYJYIZIAWUDBAIBBQCggZgwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3
# DQEJEAEEMBwGCSqGSIb3DQEJBTEPFw0yMDEwMDYyMDA2MTlaMCsGCyqGSIb3DQEJ
# EAIMMRwwGjAYMBYEFAMlvVBe2pYwLcIvT6AeTCi+KDTFMC8GCSqGSIb3DQEJBDEi
# BCDUPQKWI+Hb6+vKpIW/IynZ3OrXrbK67ckAbf9m6U3itjANBgkqhkiG9w0BAQEF
# AASCAQDBJxNCreG9oz9DGtmykJax+BPMNc1C8/h75BQoC7wSvwPk/ySg3iE7DmJy
# yaISyRlNLd+wSgQ+H6PK9KTklq9gZUgYDguDw0xBLLNlqm8eA03FbBjwCcIaOLPu
# KBbj8GS7Oq5vmjs4pRpx4389FaYaG48T8E9ZZifMuxaZ5d6b8QBQtAeAMOIsUlHW
# bvKOd42wR5D7H3FAaDu6Q0+MK0U4Bsb/pIENcSmhl0DUZrr4QbXZepFEuXhoQ57c
# t1mPE5Xe0wE+T9gZV/Bdqc5i2rdbF4f2WpnumNhZFPEqK1x9aGYQXaw6OTYSha9V
# Ccvo6cZqLkLP6uOVSO7y5CTKbmda
# SIG # End signature block
