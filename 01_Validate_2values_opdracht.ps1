# Declares the $val and $i variables with initial values of 0
$val = 0
$i = 0

# Write the While command to execute until $val is equal to 3 and $i is equal to 5
while($val -lt 3 -and $i -lt 5)
{
	# Increments $val by 1
  $val++
	# Increments $i by 2
  $i += 2
	# Prints $val and $i variables' current value
  Write-Host "$val, $i"
}