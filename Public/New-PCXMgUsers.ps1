function New-PCXMgUsers {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [array]$Users,

        [Parameter(Mandatory = $true)]
        [string]$ReportPath

    )

    begin {

        Write-PCXLog `
            -Message "========================================="

        Write-PCXLog `
            -Message "Starting New-PCXMgUsers"

        Write-PCXLog `
            -Message "========================================="

        # ==========================================================
        # INITIALIZE RESULTS ARRAY
        # ==========================================================

        $Results = @()

    }

    process {

        try {

            # ==========================================================
            # LOG TOTAL USERS
            # ==========================================================

            Write-PCXLog `
                -Message "Total users received: $($Users.Count)"

            # ==========================================================
            # PROCESS USERS
            # ==========================================================

            foreach ($User in $Users) {

                try {

                    Write-PCXLog `
                        -Message "Processing user: $($User.DisplayName)"

                    # --------------------------------------------------
                    # CREATE USER
                    # --------------------------------------------------

                    $Result = New-PCXMgUser `
                        -DisplayName $User.DisplayName `
                        -UserPrincipalName $User.UserPrincipalName `
                        -MailNickname $User.MailNickname `
                        -ReportPath $ReportPath

                    # --------------------------------------------------
                    # STORE RESULT
                    # --------------------------------------------------

                    $Results += $Result

                    # --------------------------------------------------
                    # LOG RESULT
                    # --------------------------------------------------

                    Write-PCXLog `
                        -Message "User processed: $($User.DisplayName) | Status: $($Result.Status)"

                }
                catch {

                    Write-PCXLog `
                        -Message "Failed processing user: $($User.DisplayName)" `
                        -Level ERROR

                    Write-PCXLog `
                        -Message $_.Exception.Message `
                        -Level ERROR

                    $FailureResult = [PSCustomObject]@{
                        DisplayName       = $User.DisplayName
                        UserPrincipalName = $User.UserPrincipalName
                        MailNickname      = $User.MailNickname
                        Status            = 'Failed'
                        UserId            = $null
                        ErrorMessage      = $_.Exception.Message
                        Timestamp         = Get-Date
                    }

                    # --------------------------------------------------
                    # STORE FAILURE RESULT
                    # --------------------------------------------------

                    $Results += $FailureResult

                    # --------------------------------------------------
                    # EXPORT FAILURE RESULT
                    # --------------------------------------------------

                    $FailureResult | Export-Csv `
                        -Path $ReportPath `
                        -NoTypeInformation `
                        -Append

                }

            }

        }
        catch {

            Write-PCXLog `
                -Message "New-PCXMgUsers failed" `
                -Level ERROR

            Write-PCXLog `
                -Message $_.Exception.Message `
                -Level ERROR

            throw

        }
        finally {

            Write-PCXLog `
                -Message "Processing completed"

        }

    }

    end {

        Write-PCXLog `
            -Message "Total users processed: $($Results.Count)"

        Write-PCXLog `
            -Message "========================================="

        Write-PCXLog `
            -Message "New-PCXMgUsers completed"

        Write-PCXLog `
            -Message "========================================="

        return $Results

    }

}

<#
Usage Example

$Users = @(

    [PSCustomObject]@{
        DisplayName       = "Pavana S"
        UserPrincipalName = "pavana.s@IntuneOn.onmicrosoft.com"
        MailNickname      = "pavanas"
    },

    [PSCustomObject]@{
        DisplayName       = "Harshith P"
        UserPrincipalName = "harshith.p@IntuneOn.onmicrosoft.com"
        MailNickname      = "harshithp"
    }
        
)

$Results = New-PCXMgUsers `
    -Users $Users `
    -ReportPath "C:\Reports\UserCreationReport.csv"

#>