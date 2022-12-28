# Install the Microsoft.Graph.Authentication and Microsoft.Graph.Mail packages if they're not already installed
if (!(Get-Package -Name "Microsoft.Graph.Authentication")) {
  Install-Package -Name Microsoft.Graph.Authentication -Source NuGet
}
if (!(Get-Package -Name "Microsoft.Graph.Mail")) {
  Install-Package -Name Microsoft.Graph.Mail -Source NuGet
}

# Import the Microsoft.Graph.Authentication and Microsoft.Graph.Mail namespaces
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Mail

# Set the email address and password for the Office 365 account
$username = "user@contoso.com"
$password = "password"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

# Create a new Office 365 credential object with the email address and password
$credential = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential($username, $securePassword)

# Set the from, to, subject, and body of the email
$from = "user@contoso.com"
$to = "admin@contoso.com"
$subject = "Windows Server Health Check Report"
$body = "Attached is the daily health check report for the Windows Server."

# Set the path to the CSV file to save the report
$csvFile = "C:\report.csv"

# Connect to the Office 365 account using the Connect-Graph cmdlet
Connect-Graph -Credential $credential

# Create an empty array to store the report data
$reportData = @()

# Get the current date and time
$date = Get-Date

# Add a row to the report with the current date and time
$reportData += New-Object PSObject -Property @{
  Date = $date
}

# Get the system uptime
$uptime = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty LastBootUpTime

# Calculate the uptime in days
$uptimeDays = [math]::Floor((New-TimeSpan -Start $uptime -End $date).TotalDays)

# Add a row to the report with the uptime
$reportData += New-Object PSObject -Property @{
  Uptime = "$uptimeDays days"
}

# Get the system memory usage
$memory = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty TotalVisibleMemorySize

# Calculate the memory usage in GB
$memoryGB = [math]::Round($memory / 1MB, 2)

# Add a row to the report with the memory usage
$reportData += New-Object PSObject -Property @{
  Memory = "$memoryGB GB"
}

# Get the system CPU usage
$cpu = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty LoadPercentage

# Add a row to the report with the CPU usage
$report
