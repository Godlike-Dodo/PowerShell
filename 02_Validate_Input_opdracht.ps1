#Set the initial flag value
$ValidInput = $false
 
while (-not $validInput) {
    $Input = Read-Host "Enter a valid input (e.g., 'Y' or 'N')"

    # Check the input. If it is Y or N set the validInput variable to true,
    # else write to screen in a yellow letter that the input was not valid
    ...
}
 
Write-Host -f Green "Valid input received: $input"








Antwoord goedgekeurd. 
# Set the initial flag value
$ValidInput = $false
 
while (-not $ValidInput) {
    $Input = Read-Host "Enter a valid input (e.g., 'Y' or 'N')" 
    
    # Check the input. If it is Y or N, set the ValidInput variable to true,
    # else write to screen in yellow text that the input was not valid
    if ($Input -eq 'Y' -or $Input -eq 'N') {
        $ValidInput = $true
    } 
  else {
        Write-Host -f yellow "Invalid input received: $ValidInput"
    }
}

# This will run only after valid input is received
Write-Host -f red "Final valid input received: $Input"
