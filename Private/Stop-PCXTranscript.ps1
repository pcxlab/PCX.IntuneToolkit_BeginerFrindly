function Stop-PCXTranscript {

    [CmdletBinding()]
    param()

    try {

        Stop-Transcript | Out-Null

        Write-PCXLog `
            -Message "Transcript stopped successfully"

    }
    catch {

        Write-PCXLog `
            -Message "No active transcript to stop" `
            -Level WARNING

    }

}