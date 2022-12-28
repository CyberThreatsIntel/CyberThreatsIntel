# Install the Microsoft.Graph.Authentication, Microsoft.Graph.Mail, and Microsoft.Office.Interop.Word packages if they're not already installed
if (!(Get-Package -Name "Microsoft.Graph.Authentication")) {
  Install-Package -Name Microsoft.Graph.Authentication -Source NuGet
}
if (!(Get-Package -Name "Microsoft.Graph.Mail")) {
  Install-Package -Name Microsoft.Graph.Mail -Source NuGet
}
if (!(Get-Package -Name "Microsoft.Office.Interop.Word")) {
  Install-Package -Name Microsoft.Office.Interop.Word -Source NuGet
}

# Import the Microsoft.Graph.Authentication, Microsoft.Graph.Mail, and Microsoft.Office.Interop.Word namespaces
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Mail
Import-Module Microsoft.Office.Interop.Word

# Set the email address and password for the Office 365 account
$username = "user@contoso.com"
$password = "password"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

# Create a new Office 365 credential object with the email address and password
$credential = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential($username, $securePassword)

# Set the path to the CSV file containing the list of recipients
$csvFile = "C:\recipients.csv"

# Set the subject and body of the email
$subject = "Mass Email with Attachments"
$body = "This is a mass email with attachments."

# Set the list of attachment paths
$attachments = @("C:\attachment1.txt", "C:\attachment2.pdf")

# Set the minimum and maximum sleep intervals in seconds
$minSleep = 30
$maxSleep = 60

# Connect to the Office 365 account using the Connect-Graph cmdlet
Connect-Graph -Credential $credential

# Read the list of recipients from the CSV file
$recipients = Import-Csv $csvFile

# Loop through all the recipients
foreach ($recipient in $recipients) {
  # Create a new Message object
  $message = New-Object Microsoft.Graph.Message

  # Set the from, to, subject, and body of the message
  $message.From = New-Object Microsoft.Graph.Recipient

