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
$minuten = 1;                                   # Zetten van default waarden
$server = "DC01";    
$whiteListFile = $home + '\Monitoring\WhiteList.txt';
$signaleringenFile = $home + '\Monitoring\Signaleringen.txt';

# Zorg dat de standaardwaarden worden overschreven als er argumenten zijn meegegeven bij de start
if ($args.Count -ge 1) {
    $minuten = [int]$args[0]
}
if ($args.Count -ge 2) {
    $server = $args[1]
}

$periode = New-timespan -minutes $minuten;      # bereid de tijdsinterval voor
$startTijd = Get-Date;
$stopTijd = (Get-Date) + $periode;

Write-Host "`nProcesChecker is gestart om", $startTijd, "op server", $server, "voor een periode van", $minuten, "minuten";
Set-Content -path $signaleringenFile -value $server, $datum;    # maak lege signaleringenfile
[string[]]$arrayMetWhiteList = Get-Content -Path $whiteListFile # lees de witelist in een array

# Begin van de lus die acties herhaalt tot de aangewezen minuten zijn verstreken
while ((Get-Date) -lt $stopTijd) {
    # Plaats hier de acties die binnen de lus moeten worden herhaald

    [string[]]$arrayMetProcessen = invoke-command -Computer $server {Get-Process | Select-Object -Expandproperty name}
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
    # Iets op het scherm laten bewegen gedurende de 5 seconden tussen de herhalingen
Write-Host "." -NoNewline
Start-Sleep -Seconds 1  # Wacht 1 seconde
Write-Host "." -NoNewline
Start-Sleep -Seconds 1  # Wacht 1 seconde
Write-Host "." -NoNewline
Start-Sleep -Seconds 1  # Wacht 1 seconde
Write-Host "." -NoNewline
Start-Sleep -Seconds 1  # Wacht 1 seconde
Write-Host "." -NoNewline
Start-Sleep -Seconds 1  # Wacht 1 seconde

    Wait-Event  -TimeOut 5       # heartbeat, wachtperiode tussen de herhalingen in 

# *** EIND - tot hier herhalen gedurende de $minuten ***

# nu komen de afsluitende acties, whitelist naar bestand zetten en signaleringen printen

# Vraag of de whitelist moet worden geleegd en accepteer alleen y en n
$clearWhiteList = Read-Host "Moet de whitelist worden geleegd? (y/n)"
if ($clearWhiteList -eq 'y') {
    $arrayMetWhiteList = @()  # Lege whitelist
}

# Vraag of de signaleringen moeten worden afgedrukt
$printSignaleringen = Read-Host "Moeten de signaleringen worden afgedrukt? (y/n)"
if ($printSignaleringen -eq 'y') {
    Write-Host "`n`n======================`nSignaleringen van $startTijd tot $stopTijd`n"
    Get-Content -Path $signaleringenFile
}
$arrayMetWhiteList | Out-File $whiteListFile;

# *** vraag of de signaleringen op het scherm moeten komen, accepteer y om te printen, iets anders zie je als n ***
# *** indien y: druk de signaleringen netjes af op het scherm ***
write-host " *** deze lijst moet je dus nog maken *** "

# Voeg de einddatum/tijd toe aan de afsluitende boodschap
Write-Host "======================`nProcesChecker is beëindigd om $(Get-Date)"  
