function Initialize-PCXLogging {

    [CmdletBinding()]
    param(
        [string]$LogRoot = "$env:USERPROFILE\PCX-Logs"
    )

    # ------------------------------------------------------------------
    # Define global folders
    # ------------------------------------------------------------------
    $Global:PCXLogRoot         = $LogRoot
    $Global:PCXOperationalPath = Join-Path $LogRoot "Operational"
    $Global:PCXErrorPath       = Join-Path $LogRoot "Error"
    $Global:PCXReportPath      = Join-Path $LogRoot "Reports"
    $Global:PCXTranscriptPath  = Join-Path $LogRoot "Transcript"

    # ------------------------------------------------------------------
    # Create folders if missing
    # ------------------------------------------------------------------
    $Folders = @(
        $Global:PCXLogRoot,
        $Global:PCXOperationalPath,
        $Global:PCXErrorPath,
        $Global:PCXReportPath,
        $Global:PCXTranscriptPath
    )

    foreach ($Folder in $Folders) {
        if (-not (Test-Path -Path $Folder)) {
            New-Item -Path $Folder -ItemType Directory -Force | Out-Null
        }
    }

    # ------------------------------------------------------------------
    # Create timestamped log files
    # ------------------------------------------------------------------
    $TimeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

    $Global:PCXLogFile = Join-Path `
        $Global:PCXOperationalPath `
        "PCX-$TimeStamp.log"

    $Global:PCXErrorLogFile = Join-Path `
        $Global:PCXErrorPath `
        "PCX-Error-$TimeStamp.log"

    Write-Host "PCX logging initialized." -ForegroundColor Green
    Write-Host "Log Root: $Global:PCXLogRoot" -ForegroundColor Cyan
}