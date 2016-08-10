Import-Module ActiveDirectory

﻿#The following section is used to test whether a single workstation/notebook or a list of workstations/notebooks are up.

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
	$CurrentUser = gwmi win32_computersystem -ComputerName $HostName | Select Username
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

#TODO complete User admin tool once all user Admin functions are complete
#TODO start menu to make function testing possible
Function User-Admin-Tool {
	User-Search-Tool

}
#TODO complete Search tool
Function User-Search-Tool {
	$InputUsername = Read-Host "Please enter the name of the user you wish to find (first name then last name or username)"
	$FirstName,$Surname,$Username = $Username.Split(' ')
	Get-ADUser -Filter {((Surname -like $Surname) -and (Givename -like $FirstName)) -or (SamAccountName -eq $UserName)}
}

#TODO Test that this function works
Function Reset-Password ($Username) {
	$New = Read-host "Enter the new password" -AsSecureString
	Set-ADAccountPassword $Username -NewPassword $New
	$Option = Read-Host "Would you like the user to change the password on logon?"
	#TODO insert yes or no function
	If ($Option.Lower() -eq "yes") {
		Set-ADUser $Username -ChangePasswordAtLogon $true
	}
	Elseif ($Option.lower() -eq "no") {
		break
	}
	Else {While ($Option.ToLower() -ne "yes" -Or $Option.lower() -ne "no") {
		$Option = Read-Host "Please enter yes or no"
		}
	}
}

#TODO complete enableing user Function
Function Enable-User ($Username)  {
	$Option = Read-Host "Would you like to enable this user: $Username ?"
	If ($Option.Lower() -eq "yes") {
		Enable-ADAccount $Username
	}
	Else {
		Write-Host
	}
	Write-Host "Returning to User Admin Section"
	User-Admin-Tool
}


#TODO complete disabling user Function
Function Disable-User ($Username) {
	$Option = Read-Host "Would you like to disable this user: $Username ?"
	If ($option.lower() -eq "yes") {
		Disable-ADAccount $Username
	}
	Else {
		Write-Host "Returning to User Admin Section"
		User-Admin-Tool
	}
	Write-Host "Account $Username has been disabled, returing to User Admin Tool"
	User-Admin-Tool
}


#TODO complete password age Function
Function Password-Age ($Username) {

}


#The following section is the main menu
#TODO complete the main menu section once all sections are complete
$Menu = $true

While ($Menu) {

	Write-Host "Welcome to the Ultimate IT Tool, please select from the following menu"
	Write-Host "1)Ping and Hostname Tool"
	Write-Host "2)User Administration Tool"
	Write-Host "8)To exit"
	[int]$MenuOption = Read-Host "Please type a number from the above"


	If ($MenuOption -eq 1) {
		Ping-Tool
	}
	ElseIf ($MenuOptin -eq 2) {
		Write-Host "Welcome to the User Administration Section"
		User-Admin-Tool
	}
	ElseIf ($MenuOption -eq 8) {
		break
	}
	Else {
		Write-Host "Please enter a vaild option"
	}
}


#Admin Functions
#TODO Complete yes or no option function to be placed in other functions
Function Yes-No-Loop ($Choice) {
	while ($Choice -ne "yes" -Or $Choice -ne "no") {
		$Choice = Read-Host "Please enter in yes or no"
	}
	If ($Choice.Lower() -eq "yes") {
		return $true
	}
	Elseif ($Choice.Lower() -eq "no") {
		return $false
	}
}
