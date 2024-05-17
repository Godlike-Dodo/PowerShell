# Scriptnaam:   ProcessCheck Sjabloon.txt
# functie   :   check processen van een server tegen een whitelist
# Auteur    :   Onrust
# Versie    :   1.0
# datum     :   13 mei 2024
#
# Argumenten [minuten-numerieke string [servernaam-alfanumerieke string]]
#
# de comments die beginnen en eindigen met *** zijn aanwijzingen voor jouw opdracht
#
# Zetten van default waarden
# $minuten = 1;                                   
# $server = "DC01";    

# *** zorg dat als het aantal minuten wordt meegegeven bij de start deze de default waarde vervangt ***
# *** zorg dat als een servernaam wordt meegegegevn bij de start dat die de default waarde overschrijft ***

# Parameter
param ( 
[int]$minutes = 1,
[string]$server = "DC01" 
)
write-output $server $minuten

$whiteListFile = $home + '\Monitoring\WhiteList.txt';
$signaleringenFile = $home + '\Monitoring\Signaleringen.txt';

$periode = New-timespan -minutes $minuten;      # bereid de tijdsinterval voor
$startTijd = Get-Date;
$stopTijd = (Get-Date) + $periode;

Write-Host "`nProcesChecker is gestart om", $startTijd, "op server", $server, "voor een periode van", $minuten, "minuten";
Set-Content -path $signaleringenFile -value $server, $datum;    # maak lege signaleringenfile
[string[]]$arrayMetWhiteList = Get-Content -Path $whiteListFile # lees de witelist in een array

# *** BEGIN - zorg dat de onderstaande acties herhaald worden tot het $minuten is verstreken ***

$periode = New-timespan -minutes $minuten;      # bereid de tijdsinterval voor
$timeout = new-timespan -minutes $minuten 
$sw = [diagnostics.stopwatch]::StartNew()
while ($sw.elapsed -lt $timeout)
{   
#    [string[]]$arrayMetProcessen = invoke-command -Computer $server {Get-Process | Select-Object -Expandproperty name}
    [string[]]$arrayMetProcessen = invoke-command {Get-Process | Select-Object -Expandproperty name}
    Foreach ($ProcessName in $arrayMetProcessen) {
        If (-Not ($arrayMetWhiteList -Match $processName)) {    # proces in de WhiteList?
            $answer = Read-Host -Prompt "Proces", $processName, "is onbekend, toevoegen aan whitelist (y/n)?";
            While (($answer -ne "y") -And ($answer -ne "n")) {
                $answer = Read-Host -Prompt "Keuze (y/n)";
            }
            If ($answer -Eq 'y') {                              # procesnaam toevoegen aan whitelist
                $arrayMetWhiteList += $processName;             
            }
            Else {                                              # procesnaam toevoegen aan signaleringen
                Add-Content -Path $signaleringenFile -Value $processName
            }
        }
    }
}
    # *** zorg dat ik iets op het scherm zie bewegen gedurende de 5 seconden tussen de herhalingen ***
    Wait-Event  -TimeOut 5       # heartbeat, wachtperiode tussen de herhalingen in 
    write-host "Wacht 5 secondes"

# *** EIND - tot hier herhalen gedurende de $minuten ***


# nu komen de afsluitende acties, whitelist naar bestand zetten en signaleringen printen

# *** vraag of de whitelist leeg gemaakt moet worden, accepteer alleen y en n ***
# *** als de whitelist leeg moet schrijf een lege whitelist weg, anders de huidige ***
$arrayMetWhiteList | Out-File $whiteListFile;



# *** vraag of de signaleringen op het scherm moeten komen, accepteer y om te printen, iets anders zie je als n ***
# *** indien y: druk de signaleringen netjes af op het scherm ***
Write-Host "`n`n======================`nSignaleringen van", $startTijd, "tot", $stopTijd;
write-host " *** deze lijst moet je dus nog maken *** "

# *** voeg de einddatum/tijd toe aan de afsluitende boodschap
Write-Host "======================`nProcesChecker is beëindigd om ", "`n" ;
