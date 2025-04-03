# Set hostname to TestVMScript
Rename-Computer -NewName "TestVMScript" -Force

# Create a local user Sander Sivertsen
$user = "Sander Sivertsen"
$password = ConvertTo-SecureString "Password1!" -AsPlainText -Force
New-LocalUser -Name $user -Password $password -FullName $user -PasswordNeverExpires

# Add user to local Administrators group (optional)
Add-
