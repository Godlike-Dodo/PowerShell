# Scriptnaam:   ProcessCheck Sjabloon.txt
# functie   :   check processen van een server tegen een whitelist
# Auteur    :   Lian Entjes. 128982.
# Versie    :   1.0
# datum     :   17 mei 2024
#
# Argumenten [minuten-numerieke string [servernaam-alfanumerieke string]]
#
# de comments die beginnen en eindigen met *** zijn aanwijzingen voor jouw opdracht
#

# 2 Lian
param ( 
[string]$server = "SRV001", 
[int]$minuten = 1 
)

write-output $server $minuten

# Zetten van default waarden 
$minuten = 1;                                   
$server = "SRV001";  

# deze variabele haalt de datum en tijd op
$datum_tijd = Get-Date;
    
$whiteListFile = "$home\MonTool\WhiteList.txt" # Lian
$signaleringenFile = "$home\MonTool\Signaleringen.txt" # Lian

# 3. Lian - 
# Maakt het bestand Signaleringen.txt leeg
Clear-Content -Path "C:\Users\administrator\MonTool\Signaleringen.txt"
# Schrijft de computernaam + Datum_Tijd weg in het bestand Signaleringen.txt
Set-Content -Path "C:\Users\administrator\MonTool\Signaleringen.txt" -Value "Server: $server", "Datum_tijd: $datum_tijd"
# Geef de ingegeven content weer op het scherm.
Get-Content -Path "C:\Users\administrator\MonTool\Signaleringen.txt"

# 4. Lian
# Start het script met de servernaam en datum en tijd!
Write-Host "Start de monitoringstool", $startTijd, "op server", $server, "voor een periode van", $minuten, "minuten";

# 5. Lian

$periode = New-timespan -minutes $minuten;      # bereid de tijdsinterval voor
$timeout = new-timespan -minutes $minuten 
$sw = [diagnostics.stopwatch]::StartNew()
while ($true) {

    [string[]]$arrayMetProcessen = invoke-command -Computer $server {Get-Process | Select-Object -Expandproperty name}
    [string[]]$arrayMetProcessen = invoke-command {Get-Process | Select-Object -Expandproperty name}
    # Lian - Loop 
	Foreach ($ProcessName in $arrayMetProcessen) {
        If (-Not ($whiteListFile -Match $processName)) {    # proces in de WhiteList?
            $answer = Read-Host -Prompt "Proces", $processName, "is onbekend, wilt u deze toevoegen aan whitelist? (j/n)";
            While (($answer -ne "j") -And ($answer -ne "n")) {
                $answer = Read-Host -Prompt "Keuze (j/n)";
            }
            If ($answer -Eq 'j') {                              # procesnaam toevoegen aan whitelist
                add-Content -Path "C:\Users\administrator\MonTool\WhiteList.txt" -Value $processName             
            }
            Else {                                              # procesnaam toevoegen aan signaleringen
            add-Content -Path "$home\MonTool\Signaleringen.txt" -Value $processName
            }
        }
    }
    }
    Start-Sleep 5 
    write-host "Wacht 5 secondes tot de volgende loop"


# 10. a. Vraag of de whitelist geleegd moet worden. 
Get-content -path $home\MonTool\WhiteList.txt
$answer = Read-Host -Prompt “Wilt u de whitelist legen? (j/n)";
While (($answer -ne "y") -And ($answer -ne "n")) {
                $answer = Read-Host -Prompt "Keuze (j/n)";
            }
If ($answer -Eq 'j') {Clear-Content -Path $home\MonTool\WhiteList.txt}



# 10. b.   Slaat de WhiteList.txt op. 
Out-File -path $home\MonTool\WhiteList.txt

# 10. C.       Print het bestand op het scherm indien gewenst. 
    $antwoord_printen = Read-Host -Prompt ('Wil je het bestand met signaleringen op het scherm weergeven? (j/n)')
    if ($antwoord_printen.ToUpper() -eq 'j')
    {
        Get-Content -Path $signaleringenFile 
    }


# 10. d.        Sluit het script
Exit




