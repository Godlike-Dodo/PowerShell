# Aantal elementen in de array
$NumArgs = $args.Length
 
# loop door alle elementen van de args array
for ($i=0; $i -le $NumArgs; $i++)

{

	# Laat zien wat er op elk adres van de array staat

	# Write-Host "Line $($1) : $(args[$i])"
 
	if ($args[$i] -eq "-server" )

	{

		$i++

		$my_server = $args[$i]

	}
 
	elseif ( $args[$i] -eq "-minutes" )

	{

		$i++	

		$my_minutes = $args[$i]

	}

}
 
Write-Host "Server: $($my_server)"

Write-Host "Minutes: $($my_minutes)"