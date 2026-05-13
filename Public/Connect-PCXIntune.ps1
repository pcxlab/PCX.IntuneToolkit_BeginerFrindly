function Connect-PCXIntune {

    [CmdletBinding()]
    param()

    begin {
        Write-PCXLog "Starting Connect-PCXIntune"
    }

    process {
        try {

            # Remove any broken session first
            if (Get-MgContext) {
                Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
            }

            # Ensure module
            if (-not (Get-Module Microsoft.Graph)) {
                Import-Module Microsoft.Graph -Force
            }

            Write-PCXLog "Connecting to Microsoft Graph..."

            Connect-MgGraph `
                -Scopes "DeviceManagementApps.ReadWrite.All", "Group.ReadWrite.All" `
                -ContextScope Process `
                -NoWelcome

            $ctx = Get-MgContext

            if (-not $ctx) {
                throw "Graph connection failed"
            }

            Write-PCXLog "Graph connected successfully"
            Write-PCXLog "Tenant: $($ctx.TenantId)"

            return $ctx
        }
        catch {
            Write-PCXLog "Graph connection failed: $_" "ERROR"
            throw
        }
        finally {

            Write-PCXLog `
                -Message "Connect-PCXIntune process block completed"

        }
    }
    end {

        Write-PCXLog `
            -Message "========================================="

        Write-PCXLog `
            -Message "Connect-PCXIntune completed"

        Write-PCXLog `
            -Message "========================================="

    }
}