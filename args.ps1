#Aantal elementen in de args array
$NumArgs = $args.Length

#Loop door alle elementen van de args array
for ($i=0; $i -le $NumArgs; $i++)
{
       Write-Host "Line ($i) : ($args [$i])"
}







