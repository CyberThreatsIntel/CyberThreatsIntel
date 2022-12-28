

# Install the SharePointPnPPowerShellOnline module if it's not already installed
if (!(Get-Module -Name "SharePointPnPPowerShellOnline")) {
  Install-Module -Name SharePointPnPPowerShellOnline -Force
}

# Import the SharePointPnPPowerShellOnline module
Import-Module -Name SharePointPnPPowerShellOnline

# Set the username and password for the SharePoint account
$username = "user@contoso.com"
$password = "password"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

# Create a new PSCredential object with the username and password
$credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)

# Connect to SharePoint using the Connect-PnPOnline cmdlet and the PSCredential object
Connect-PnPOnline -Url https://contoso.sharepoint.com -Credentials $credential

# Set the local folder path and the SharePoint folder path
$localFolder = "C:\local\folder"
$sharePointFolder = "/sites/contoso/Shared Documents/folder"

# Set the interval for checking for new files in seconds
$interval = 60

# Set the flag to indicate whether the script is running
$running = $true

# Create an infinite loop to check for new files periodically
while ($running) {
  # Get a list of all files in the local folder
  $localFiles = Get-ChildItem $localFolder

  # Loop through all the local files
  foreach ($localFile in $localFiles) {
    # Check if the file already exists in the SharePoint folder
    if (!(Test-Path "$sharePointFolder\$($localFile.Name)")) {
      # If the file doesn't exist, upload it to the SharePoint folder
      Add-PnPFile -Path "$localFolder\$($localFile.Name)" -Folder $sharePointFolder
    }
  }

  # Wait for the specified interval before checking for new files again
  Start-Sleep -Seconds $interval
}

