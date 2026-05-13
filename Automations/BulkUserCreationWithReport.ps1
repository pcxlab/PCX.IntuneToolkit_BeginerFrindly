# Import your module
import-Module "C:\Projects\PCX.IntuneToolkit" -Force

<# 
Import-Module PCX.IntuneToolkit -Force
Remove-Module PCX.IntuneToolkit -Force
Get-Module -Name PCX.IntuneToolkit
Get-Command -Module PCX.IntuneToolkit
#>

# Initialize logging framework
Initialize-PCXLogging

# Start transcript (optional but recommended)
Start-PCXTranscript -Enable

# Connect to Microsoft Graph
Connect-PCXIntune
# or:
# Connect-MgGraph -Scopes "User.ReadWrite.All","Directory.ReadWrite.All" `
#     -UseDeviceAuthentication `
#     -ContextScope Process

# Create unique report path for this execution
$TimeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$ReportPath = Join-Path `
    $Global:PCXReportPath `
    "UserCreationReport-$TimeStamp.csv"

# Run automation
$Results = New-PCXMgUsersFromCSV `
    -Path "C:\Projects\Mangalore_Udupi_Employees_6.csv" `
    -ExportReport `
    -ReportPath $ReportPath

<#
# Run automation
$Results = New-PCXMgUsersFromCSV `
    -Path "C:\Projects\Coastal_Karnataka_Employees_50000_Shuffled.csv" `
    -ExportReport `
    -ReportPath $ReportPath

    #>

# Show summary
$Results | Group-Object Status | Format-Table Name, Count -AutoSize

# Show report location
Write-Host "Report saved to: $ReportPath" -ForegroundColor Green

Stop-PCXTranscript