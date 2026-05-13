function New-PCXMgUsersFromCSV {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$ReportPath

    )

    begin {

        Write-PCXLog `
            -Message "========================================="

        Write-PCXLog `
            -Message "Starting New-PCXMgUsersFromCSV"

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
            # IMPORT CSV
            # ==========================================================

            Write-PCXLog `
                -Message "Importing CSV file"

            $Employees = Import-Csv `
                -Path $Path

            Write-PCXLog `
                -Message "Imported $($Employees.Count) users from CSV"

            # ==========================================================
            # PROCESS USERS
            # ==========================================================

            foreach ($Employee in $Employees) {

                Write-PCXLog `
                    -Message "Processing user: $($Employee.Names)"

                # ------------------------------------------------------
                # CREATE USER
                # ------------------------------------------------------

                $Result = New-PCXMgUser `
                    -DisplayName $Employee.Names `
                    -UserPrincipalName $Employee.UserPrincipalName `
                    -MailNickname $Employee.MailNickname `
                    -ReportPath $ReportPath

                # ------------------------------------------------------
                # STORE IN MEMORY
                # ------------------------------------------------------

                $Results += $Result

                # ------------------------------------------------------
                # LOG STATUS
                # ------------------------------------------------------

                Write-PCXLog `
                    -Message "User processed: $($Employee.Names) | Status: $($Result.Status)"

            }

            # ==========================================================
            # RETURN RESULTS
            # ==========================================================

            return $Results

        }
        catch {

            Write-PCXLog `
                -Message "New-PCXMgUsersFromCSV failed" `
                -Level ERROR

            Write-PCXLog `
                -Message $_.Exception.Message `
                -Level ERROR

            throw

        }
        finally {

            Write-PCXLog `
                -Message "CSV processing completed"

        }

    }

    end {

        Write-PCXLog `
            -Message "========================================="

        Write-PCXLog `
            -Message "New-PCXMgUsersFromCSV completed"

        Write-PCXLog `
            -Message "========================================="

    }

}

<# Usage Example

$Results = New-PCXMgUsersFromCSV `
    -Path "C:\Projects\Mangalore_Udupi_Employees_6.csv" `
    -ReportPath $ReportPath

$Results | Format-Table -AutoSize

#>