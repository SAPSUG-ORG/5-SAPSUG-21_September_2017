<#
	.SYNOPSIS
		PowerShell based interactive reddit browser

	.DESCRIPTION
		Uses PowerShell to establish a connection to reddit and pulls down a JSON payload for the specified subreddit.  The number of threads (default 3) specified by the user is then evaluated and output to the console window.  If the thread is picture-based the user has the option to display those images in their native browser.
	
	.PARAMETER Subreddit
		The name of the desired subreddit - Ex PowerShell or aww
	
	.PARAMETER Threads
		The number of threads that will be pulled down - the default is 3
	
	.PARAMETER ShowPics
		Determines if pics will be shown (if available)
	
	.EXAMPLE
		PS C:\> Get-Reddit -Subreddit PowerShell

		Retrieves the top 3 threads of the PowerShell subreddit
	.EXAMPLE
		PS C:\> Get-Reddit -Subreddit aww -Threads 4

		Retrieves the top 4 threads of the aww subreddit
	.EXAMPLE
		PS C:\> Get-Reddit -Subreddit PowerShell -ShowPics

		Retrieves the top 3 threads of the aww subreddit and if pictures are available, displays them in the native browser
	.NOTES
		Additional information about the function.
#>
function Get-Reddit {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $false,
				   Position = 1,
				   HelpMessage = 'The name of the desired subreddit')]
		[string]$Subreddit,
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false,
				   Position = 2,
				   HelpMessage = 'The number of threads that will be pulled down')]
		[int]$Threads = 3,
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false,
				   Position = 3,
				   HelpMessage = 'Determines if pics will be shown (if available)')]
		[switch]$ShowPics
	)
	Write-Verbose "Loading subreddit: $Subreddit"
	$sub = $subreddit
	Write-Verbose "Loading $Threads Threads"
	[array]$Index = (1 .. $Threads)
	$WC = New-Object net.webclient
	Write-Verbose "Initiating Download"
	try {
		$global:SubStorage = $WC.Downloadstring("http://www.reddit.com/r/$sub/.json") | ConvertFrom-json
		Write-Verbose "Download successfull."
		[array]::Reverse($Index)
		Write-Verbose "Generating output..."
		$Index | ForEach-Object {
			$ix = $_ - 1
			$url = $null
			$url = $SubStorage.data.children.Item($ix).data.url
			"`n_ $_ ______________________________________________________"
			"title-------- " + $SubStorage.data.children.Item($ix).data.title
			"url---------- " + $url
			"PermaLink---- www.reddit.com" + $SubStorage.data.children.Item($ix).data.permalink
			"score-------- " + $SubStorage.data.children.Item($ix).data.score
			"ups---------- " + $SubStorage.data.children.Item($ix).data.ups
			"downs-------- " + $SubStorage.data.children.Item($ix).data.downs
			"author------- " + $SubStorage.data.children.Item($ix).data.author
			"Num_Comments- " + $SubStorage.data.children.Item($ix).data.num_comments
			if ($url -like "*i.redd.it*" -or $url -like "*imgur*" -and $ShowPics) {
				Show-Pics -url $url
			}
		}
		Write-Verbose "Completed."
	}
	catch {
		Write-Output "An error was encountered accessing reddit.com . A good next step would be to try accessing from your browser to see if that works instead."
		Write-Verbose $_
	}
}

function Show-Pics {
	[CmdletBinding()]
	param (
		[string]$url
	)
	
	begin {
		Write-Verbose "Starting browser with $url"
	}
	
	process {
		try {
			(New-Object -Com Shell.Application -ErrorAction Stop).Open($url)
			Write-Verbose "Browser launch successful."
		}
		catch {
			Write-Output "An error was encountered launching the browser window"
			Write-Verbose $_
		}
	}
	end {
		Write-Verbose "All done."
	}
}