function New-PCXMgUser {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $true)]
        [string]$UserPrincipalName,

        [Parameter(Mandatory = $true)]
        [string]$MailNickname,

        [Parameter(Mandatory = $true)]
        [string]$ReportPath

    )

    begin {

        Write-PCXLog `
            -Message "========================================="

        Write-PCXLog `
            -Message "Starting New-PCXMgUser"

        Write-PCXLog `
            -Message "========================================="

    }

    process {

        try {

            # ==========================================================
            # GRAPH SESSION
            # ==========================================================

            Write-PCXLog `
                -Message "Using existing Graph session"

            # ==========================================================
            # PREPARE PASSWORD PROFILE
            # ==========================================================

            $PasswordProfile = @{
                Password                      = "TempP@ss1234"
                ForceChangePasswordNextSignIn = $true
            }

            Write-PCXLog `
                -Message "Password profile prepared"

            # ==========================================================
            # CREATE USER
            # ==========================================================

            Write-PCXLog `
                -Message "Creating user: $DisplayName"

            $User = New-MgUser `
                -DisplayName $DisplayName `
                -UserPrincipalName $UserPrincipalName `
                -MailNickname $MailNickname `
                -AccountEnabled:$true `
                -PasswordProfile $PasswordProfile

            Write-PCXLog `
                -Message "User created successfully"

            Write-PCXLog `
                -Message "User ID: $($User.Id)"

            # ==========================================================
            # BUILD RESULT
            # ==========================================================

            $Result = [PSCustomObject]@{
                DisplayName       = $DisplayName
                UserPrincipalName = $UserPrincipalName
                MailNickname      = $MailNickname
                Status            = 'Success'
                UserId            = $User.Id
                ErrorMessage      = $null
                Timestamp         = Get-Date
            }

            # ==========================================================
            # EXPORT REPORT
            # ==========================================================

            $Result | Export-Csv `
                -Path $ReportPath `
                -NoTypeInformation `
                -Append

            return $Result

        }
        catch {

            Write-PCXLog `
                -Message "New-PCXMgUser failed" `
                -Level ERROR

            Write-PCXLog `
                -Message $_.Exception.Message `
                -Level ERROR

            $Result = [PSCustomObject]@{
                DisplayName       = $DisplayName
                UserPrincipalName = $UserPrincipalName
                MailNickname      = $MailNickname
                Status            = 'Failed'
                UserId            = $null
                ErrorMessage      = $_.Exception.Message
                Timestamp         = Get-Date
            }

            $Result | Export-Csv `
                -Path $ReportPath `
                -NoTypeInformation `
                -Append

            return $Result

        }
        finally {

            Write-PCXLog `
                -Message "New-PCXMgUser process block completed"

        }

    }

    end {

        Write-PCXLog `
            -Message "========================================="

        Write-PCXLog `
            -Message "New-PCXMgUser completed"

        Write-PCXLog `
            -Message "========================================="

    }

}

<# 
$Result = New-PCXMgUser `
    -DisplayName "Kiran Shetty" `
    -UserPrincipalName "kiran.shetty@IntuneOn.onmicrosoft.com" `
    -MailNickname "kirans" `
    -ReportPath $ReportPath

$Result | Format-Table -AutoSize
#>