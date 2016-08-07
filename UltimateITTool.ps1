#The following section is used to test whether a single workstation/notebook or a list of workstations/notebooks are up.


Function Ping-Test {
	$ComputerStatus = Test-Connection -Count 1 -ComputerName $Computer -Quiet 
	if ($ComputerStatus) {
		Write-Host -ForegroundColor Green "$Computer is turned on" 
		Display-IPAddress
		Display-WorkstationInfo $Computer
		Display-LoggedOnUser $Computer
	}
	Else { 
		Write-Host -ForegroundColor Red "$Computer is down"
		}
}


Function Display-IPAddress {
	Test-Connection -Count 1 -ComputerName $Computer | ForEach-Object {
	$IPAddress = $_.IPV4Address
	Write-Host -ForegroundColor Green "IPaddress: $IPAddress"
	}
}


Function Display-WorkstationInfo ($HostName) {
	Get-WmiObject -Computer $HostName -Class Win32_ComputerSystem | ForEach-Object {
		$DomainName = $_.Domain
        $Model = $_.Model
		Write-Host -ForegroundColor Green "Domain: $DomainName"
        Write-Host -ForegroundColor Green "Model: $Model"
	}
}


Function Display-LoggedOnUser ($HostName) {
	$CurrentUser = gwmi win32_computersystem -Computer $HostName | Select Username
	Write-Host -ForegroundColor Green "Current User: $CurrentUser"
}


Function Ping-Tool {

	$Choice = Read-Host "Would you like check if a single workstation/notebook is up or a list? `n Press '1' for single workstation. Press '2' for a list."

	if ($Choice -eq '1') {
		$Computer = Read-Host "Please enter the name of the workstation/notebook"
		Ping-Test
	}
	Else {
		$FilePath = Read-Host "Please enter the filepath:"

		$AllComputers = @()
		$AllLaptops = @()

		Import-Csv $FilePath | ForEach-Object {
		$AllComputers += $_.computers
		$AllLaptops += $_.laptops
		}

		Write-Host "Checking if workstations are up..."
		ForEach ($Computer in $AllComputers) {
			Ping-Test
		}

	}
}

#The following section is the user administration tool


Function User-Admin-Tool {
	
}

#The following section is the main menu
$Menu = $true

While ($Menu) {

	Write-Host "Welcome to the Ultimate IT Tool, please select from the following menu:"
	Write-Host "1)Ping and Hostname Tool"
	Write-Host "2)User Administration Tool"
	Write-Host "8)To exit"
	[int]$MenuOption = Read-Host "Please type a number from the above"


	If ($MenuOption -eq 1) {
		Ping-Tool
	}
	ElseIf ($MenuOptin -eq 2) {
		User-Admin-Tool
	}
	ElseIf ($MenuOption -eq 8) {
		break
	}
}
