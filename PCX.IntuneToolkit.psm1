# PCX.IntuneToolkit.psm1

# Load Private Functions
Get-ChildItem "$PSScriptRoot\Private\*.ps1" | ForEach-Object {
    . $_.FullName
}

# Load Public Functions
Get-ChildItem "$PSScriptRoot\Public\*.ps1" | ForEach-Object {
    . $_.FullName
}

Export-ModuleMember -Function *