# Password length
$length = 8
# Valid password characters
$characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+"

# Start counter
$i = 0
# Empty start password
$password = ''

while ($i -lt $length) {
	# Create a variable $index that holds a random number between 0 and the length of the $characters string
	...
	# Read the character on the found postition from the string of valid characters
	...

	# Do next
	$i++
}

# Write the password to the screen 
Write-Host "Your password is: $password"





Antwoorden
# Password length
$length = 8
# Valid password characters
$characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+"

# Start counter
$i = 0
# Empty start password
$password = ''

while ($i -lt $length) {
	# Create a variable $index that holds a random number between 0 and the length of the $characters string
	$index = Get-Random -Minimum 0 -Maximum $characters.Length
	# Read the character on the found postition from the string of valid characters
	$password += $characters[$index]
	# Do next
	$i++
}

# Write the password to the screen 
Write-Host "Your password is: $password"