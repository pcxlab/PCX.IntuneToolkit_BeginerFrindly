function Start-PCXTranscript {

    [CmdletBinding()]
    param(
        [switch]$Enable
    )

    if (-not $Enable) {
        return
    }

    # Auto initialize if needed
    if (-not $Global:PCXTranscriptPath) {
        Initialize-PCXLogging
    }

    $TimeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

    $TranscriptFile = Join-Path `
        $Global:PCXTranscriptPath `
        "Transcript-$TimeStamp.txt"

    Start-Transcript `
        -Path $TranscriptFile `
        -Force | Out-Null

    Write-PCXLog `
        -Message "Transcript started: $TranscriptFile"
}