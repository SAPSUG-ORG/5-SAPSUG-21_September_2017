Write-Host "Initializing the Shell..." -ForegroundColor DarkCyan -BackgroundColor White
Write-Host "Initilization complete. Welcome back Jake." -ForegroundColor Cyan -BackgroundColor Black
Set-PSReadlineOption -TokenKind Command -ForegroundColor Cyan
Set-PSReadlineOption -ContinuationPromptForegroundColor Magenta -ContinuationPrompt ">>>"

$global:sysvars = Get-Variable | select -ExpandProperty Name
$global:sysvars += 'sysvars'

function ca {
    $sysvariables = $sysvars
    #clear all errors
    $error.clear()
    #clear all non-system variables
    Get-Variable | where {$sysvariables -notcontains $_.Name -and $_.Name -ne "sysvariables"} | foreach {Remove-Variable $_.name -Scope Global}
    Clear
    cd c:\
}