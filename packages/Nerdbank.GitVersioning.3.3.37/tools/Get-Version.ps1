<#
.SYNOPSIS
Finds the git commit ID that was built to produce some specific version of an assembly.
.PARAMETER ProjectDirectory
The directory of the project that built the assembly, within the git repo.
#>
[CmdletBinding(SupportsShouldProcess)]
Param(
    [Parameter()]
    [string]$ProjectDirectory="."
)

if (-not (Test-Path variable:global:DependencyBasePath) -or !$DependencyBasePath) { $DependencyBasePath = "$PSScriptRoot\..\build\MSBuildFull" }
$null = [Reflection.Assembly]::LoadFile((Resolve-Path "$DependencyBasePath\Validation.dll"))
$null = [Reflection.Assembly]::LoadFile((Resolve-Path "$DependencyBasePath\NerdBank.GitVersioning.dll"))
$null = [Reflection.Assembly]::LoadFile((Resolve-Path "$DependencyBasePath\LibGit2Sharp.dll"))
$null = [Reflection.Assembly]::LoadFile((Resolve-Path "$DependencyBasePath\Newtonsoft.Json.dll"))

$ProjectDirectory = (Resolve-Path $ProjectDirectory).ProviderPath

try {
    [Nerdbank.GitVersioning.GitExtensions]::HelpFindLibGit2NativeBinaries($DependencyBasePath)
    $CloudBuild = [Nerdbank.GitVersioning.CloudBuild]::Active
    $VersionOracle = [Nerdbank.GitVersioning.VersionOracle]::Create($ProjectDirectory, $null, $CloudBuild)
    $VersionOracle
}
finally {
    # the try is here so Powershell aborts after first failed step.
}

# SIG # Begin signature block
# MIIfwgYJKoZIhvcNAQcCoIIfszCCH68CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBov0whQPvFhHUf
# l8AZJ0pHue/YiSgtjhyUYWfANjKzdaCCDfswggPFMIICraADAgECAhACrFwmagtA
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
# IeujfFoxghEdMIIRGQIBATBuMFoxCzAJBgNVBAYTAlVTMRgwFgYDVQQKEw8uTkVU
# IEZvdW5kYXRpb24xMTAvBgNVBAMTKC5ORVQgRm91bmRhdGlvbiBQcm9qZWN0cyBD
# b2RlIFNpZ25pbmcgQ0ECEAVik3iCB8bMjt77l0lcFQcwDQYJYIZIAWUDBAIBBQCg
# gbQwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwG
# CisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEk+lzZdoUANmBgR7owTO8WZ3lCm
# CXRiLAqKgVR7g2t+MEgGCisGAQQBgjcCAQwxOjA4oAKAAKEygDBodHRwczovL2dp
# dGh1Yi5jb20vZG90bmV0L05lcmRiYW5rLkdpdFZlcnNpb25pbmcwDQYJKoZIhvcN
# AQEBBQAEggEAUJpbwrEnCLb63kLPIj/fXU5nQzMCANsO8U6Ou3I/ot5G9ZHQ5Qc9
# SRQp4KrwIPUZ/fasu/QowtoESC6yBWF47fI5OYlL58aTJbpbc0bwKUh0+c/nsyP/
# DOOzmLEXk/NZi83P2nexuCv8wVibECXE79+F4ZFO6+wdPINHW2T1N5A8LWihCRt4
# Uhq996j7U4yVtIrc+2YdertVgDaTzi7GDLtKN9qXASq7yndL+jLEuG9PtWZOgrqN
# lI8R6qpKodydGloNNQvEur5CJCluG5cWXaduXzaAIbnOa7K0zb71fMlYSCDx7uNj
# 42IHv/20TZdrGLgJcmN+dZAHd0iiD9rzLqGCDskwgg7FBgorBgEEAYI3AwMBMYIO
# tTCCDrEGCSqGSIb3DQEHAqCCDqIwgg6eAgEDMQ8wDQYJYIZIAWUDBAIBBQAweAYL
# KoZIhvcNAQkQAQSgaQRnMGUCAQEGCWCGSAGG/WwHATAxMA0GCWCGSAFlAwQCAQUA
# BCAv/RulKI+dqILz9TUKVPUd2MvITyy00Ww83BVx8BSDsAIRAMaN82uTeVJJSooP
# QlBD8yIYDzIwMjAxMDA2MjAwNjE5WqCCC7swggaCMIIFaqADAgECAhAEzT+FaK52
# xhuw/nFgzKdtMA0GCSqGSIb3DQEBCwUAMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNV
# BAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0EwHhcN
# MTkxMDAxMDAwMDAwWhcNMzAxMDE3MDAwMDAwWjBMMQswCQYDVQQGEwJVUzEXMBUG
# A1UEChMORGlnaUNlcnQsIEluYy4xJDAiBgNVBAMTG1RJTUVTVEFNUC1TSEEyNTYt
# MjAxOS0xMC0xNTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOlkNZz6
# qZhlZBvkF9y4KTbMZwlYhU0w4Mn/5Ts8EShQrwcx4l0JGML2iYxpCAQj4HctnRXl
# uOihao7/1K7Sehbv+EG1HTl1wc8vp6xFfpRtrAMBmTxiPn56/UWXMbT6t9lCPqdV
# m99aT1gCqDJpIhO+i4Itxpira5u0yfJlEQx0DbLwCJZ0xOiySKKhFKX4+uGJcEQ7
# je/7pPTDub0ULOsMKCclgKsQSxYSYAtpIoxOzcbVsmVZIeB8LBKNcA6Pisrg09ez
# OXdQ0EIsLnrOnGd6OHdUQP9PlQQg1OvIzocUCP4dgN3Q5yt46r8fcMbuQhZTNkWb
# UxlJYp16ApuVFKMCAwEAAaOCAzgwggM0MA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMB
# Af8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMIIBvwYDVR0gBIIBtjCCAbIw
# ggGhBglghkgBhv1sBwEwggGSMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdp
# Y2VydC5jb20vQ1BTMIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBl
# ACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBu
# AHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0
# AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0
# AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBl
# AG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5
# ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABl
# AHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMAsGCWCGSAGG/WwD
# FTAfBgNVHSMEGDAWgBT0tuEgHf4prtLkYaWyoiWyyBc1bjAdBgNVHQ4EFgQUVlMP
# wcYHp03X2G5XcoBQTOTsnsEwcQYDVR0fBGowaDAyoDCgLoYsaHR0cDovL2NybDMu
# ZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC10cy5jcmwwMqAwoC6GLGh0dHA6Ly9j
# cmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtdHMuY3JsMIGFBggrBgEFBQcB
# AQR5MHcwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBPBggr
# BgEFBQcwAoZDaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0U0hB
# MkFzc3VyZWRJRFRpbWVzdGFtcGluZ0NBLmNydDANBgkqhkiG9w0BAQsFAAOCAQEA
# LoOhRAVKBOO5MlL62YHwGrv4CY0juT3YkqHmRhxKL256PGNuNxejGr9YI7JDnJSD
# TjkJsCzox+HizO3LeWvO3iMBR+2VVIHggHsSsa8Chqk6c2r++J/BjdEhjOQpgsOK
# C2AAAp0fR8SftApoU39aEKb4Iub4U5IxX9iCgy1tE0Kug8EQTqQk9Eec3g8icndc
# f0/pOZgrV5JE1+9uk9lDxwQzY1E3Vp5HBBHDo1hUIdjijlbXST9X/AqfI1579JSN
# 3Z0au996KqbSRaZVDI/2TIryls+JRtwxspGQo18zMGBV9fxrMKyh7eRHTjOeZ2oo
# tU3C7VuXgvjLqQhsUwm09zCCBTEwggQZoAMCAQICEAqhJdbWMht+QeQF2jaXwhUw
# DQYJKoZIhvcNAQELBQAwZTELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0
# IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNl
# cnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTE2MDEwNzEyMDAwMFoXDTMxMDEwNzEy
# MDAwMFowcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcG
# A1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBB
# c3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEP
# ADCCAQoCggEBAL3QMu5LzY9/3am6gpnFOVQoV7YjSsQOB0UzURB90Pl9TWh+57ag
# 9I2ziOSXv2MhkJi/E7xX08PhfgjWahQAOPcuHjvuzKb2Mln+X2U/4Jvr40ZHBhpV
# fgsnfsCi9aDg3iI/Dv9+lfvzo7oiPhisEeTwmQNtO4V8CdPuXciaC1TjqAlxa+DP
# IhAPdc9xck4Krd9AOly3UeGheRTGTSQjMF287DxgaqwvB8z98OpH2YhQXv1mblZh
# JymJhFHmgudGUP2UKiyn5HU+upgPhH+fMRTWrdXyZMt7HgXQhBlyF/EXBu89zdZN
# 7wZC/aJTKk+FHcQdPK/P2qwQ9d2srOlW/5MCAwEAAaOCAc4wggHKMB0GA1UdDgQW
# BBT0tuEgHf4prtLkYaWyoiWyyBc1bjAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYun
# pyGd823IDzASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBhjATBgNV
# HSUEDDAKBggrBgEFBQcDCDB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0
# dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2NhY2Vy
# dHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDCBgQYD
# VR0fBHoweDA6oDigNoY0aHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# QXNzdXJlZElEUm9vdENBLmNybDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDBQBgNVHSAESTBHMDgGCmCG
# SAGG/WwAAgQwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29t
# L0NQUzALBglghkgBhv1sBwEwDQYJKoZIhvcNAQELBQADggEBAHGVEulRh1Zpze/d
# 2nyqY3qzeM8GN0CE70uEv8rPAwL9xafDDiBCLK938ysfDCFaKrcFNB1qrpn4J6Jm
# vwmqYN92pDqTD/iy0dh8GWLoXoIlHsS6HHssIeLWWywUNUMEaLLbdQLgcseY1jxk
# 5R9IEBhfiThhTWJGJIdjjJFSLK8pieV4H9YLFKWA1xJHcLN11ZOFk362kmf7U2GJ
# qPVrlsD0WGkNfMgBsbkodbeZY4UijGHKeZR+WfyMD+NvtQEmtmyl7odRIeRYYJu6
# DC0rbaLEfrvEJStHAgh8Sa4TtuF8QkIoxhhWz0E0tmZdtnR79VYzIi8iNrJLokqV
# 2PWmjlIxggJNMIICSQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhE
# aWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhAEzT+FaK52
# xhuw/nFgzKdtMA0GCWCGSAFlAwQCAQUAoIGYMBoGCSqGSIb3DQEJAzENBgsqhkiG
# 9w0BCRABBDAcBgkqhkiG9w0BCQUxDxcNMjAxMDA2MjAwNjE5WjArBgsqhkiG9w0B
# CRACDDEcMBowGDAWBBQDJb1QXtqWMC3CL0+gHkwovig0xTAvBgkqhkiG9w0BCQQx
# IgQg0jmjhSQ/+Om4M+iSp6gqdyu4iiaon4t1P5A4ZGoEXAIwDQYJKoZIhvcNAQEB
# BQAEggEAT+/NEmv4NQpNvZZyeBMaunp+ysVkd0SoRtlvTv6hSEipCTSDG9yDNeST
# lWLcekqvPRVVGixvyCxyRCw+3seQim/Pv8yJu+8+IMWK8eBAt7cLeXFzFGrslJa0
# W+YAdCoWSJOD60H3yc5ZlsAhm4JPS64suuJPTZYmDDsKUMn5NZxL8Skq2Y3nYu3c
# xM9d/xTnQvgToiguVGy3CtZ+fQC8rTS6uk+cRKLZYl/68F55ygLqf9qNmWHMbwb9
# lt9qebY2W/HYnsAQavPDUaUxnMCZIdiNjEeN1EXyUJtMA+H0K6ic/IHtV4F9aj/r
# Mc8bpT7++5HkX15q3VTbJ/uhG2DebQ==
# SIG # End signature block
