# Create a new firewall rule named 'Sander_Test' for TCP and UDP on port 55231

$ruleName = "Sander_Test"
$port = 55231

# Add TCP rule
New-NetFirewallRule -DisplayName "$ruleName - TCP" `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort $port

# Add UDP rule
New-NetFirewallRule -DisplayName "$ruleName - UDP" `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol UDP `
                    -LocalPort $port


