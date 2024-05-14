param ( 
[int]$minutes = 1,
[string]$server = "DC01" 
)

if ($minutes -eq 1 -and $server -eq "DC01") {
    "Lokale server en 1 minuut"
} else {
    "Andere server en ander aantal minuten"
}

write-output $server $minutes


