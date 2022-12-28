# Set the list of IP addresses to ping
$ipAddresses = @("192.168.0.1", "192.168.0.2", "192.168.0.3")

# Set the interval for pinging the IP addresses in seconds
$interval = 300

# Set the SMTP server, port, and credentials for the email account
$smtpServer = "smtp.example.com"
$smtpPort = 587
$smtpUsername = "user@example.com"
$smtpPassword = "password"

# Set the from and to addresses for the email
$fromAddress = "user@example.com"
$toAddress = "admin@example.com"

# Set the subject and body of the email
$subject = "IP Address Status"
$body = "One or more IP addresses are down."

# Set the flag to indicate whether the script is running
$running = $true

# Create an infinite loop to check the IP addresses periodically
while ($running) {
  # Set the flag to indicate whether any IP addresses are down
  $ipDown = $false

  # Loop through all the IP addresses
  foreach ($ipAddress in $ipAddresses) {
    # Ping the IP address and check the response
    $pingResponse = Test-Connection $ipAddress -Count 1 -Quiet
    if (!$pingResponse) {
      # If the IP is down, set the flag to true
      $ipDown = $true
      break
    }
  }

  # If any IP addresses are down, send an email alert
  if ($ipDown) {
    # Create a new MailMessage object
    $mail = New-Object Net.Mail.MailMessage

    # Set the from, to, subject, and body of the email
    $mail.From = $fromAddress
    $mail.To.Add($toAddress)
    $mail.Subject = $subject
    $mail.Body = $body

    # Create a new SmtpClient object
    $smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)

    # Set the SMTP credentials and enable SSL
    $smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUsername, $smtpPassword)
    $smtp.EnableSsl = $true

    # Send the email
    $smtp.Send($mail)
  }

  # Wait for the specified interval before checking the IP addresses again
  Start-Sleep -Seconds $interval
}
