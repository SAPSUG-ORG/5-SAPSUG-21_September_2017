#show PSReadline Module
Get-Module
#paramter listing: Ctrl+Space
#ctrl shortcuts for navigation:
    #Ctrl+LeftArror
    #Ctrl+RightArror
    #Ctrl+Enter
#demo multi line editing
Get-Service |
where {
    $_.Status -eq "Running"
}
#demo session history (up vs history)
Get-History
#searching history with Ctrl+R / Ctrl+S
#adjust history settings
Get-PSReadlineOption | select *history*
#clear session history Alt+F7 
#truly delete history file
Get-PSReadlineOption | select -expand historysavepath | Remove-Item -whatif

#adjust color options
Get-PSReadlineOption | select *color*
#change command color
Set-PSReadlineOption -TokenKind Command -ForegroundColor Cyan
#change continuation prompt
Set-PSReadlineOption -ContinuationPromptForegroundColor Magenta -ContinuationPrompt ">>>"
#demo the readline key handler
Get-PSReadlineKeyHandler
Get-PSReadlineKeyHandler | where {$_.Key -eq "Tab"}
#make it more "bash like"
Set-PSReadlineKeyHandler -Key Tab -Function Complete
#menu bash example
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
#back to default
Set-PSReadlineKeyHandler -Key Tab -Function TabCompleteNext

#profile work
$PROFILE
#more than just current user, current host
$PROFILE | Format-List * -Force
#adjust profile