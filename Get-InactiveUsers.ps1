
# 1. Przygotowanie zmiennych 
$dzisiaj = Get-Date -Format "yyyy-MM-dd"
$sciezka = "C:\Users\$env:USERNAME\Desktop\Raport_AD_$dzisiaj.csv"
$dataGraniczna = (Get-Date).AddDays(-90)
$server = "server_ip" 

# --- LOGOWANIE ---
# Skrypt zapyta o hasło tylko, jeśli jeszcze nie jest zapisane w tej sesji
if (-not $script:mojeHaslo) {
    $script:mojeHaslo = Get-Credential
}

# 2. Filtrowanie - Data ostatniego logowania, wygasanie konta
Get-ADUser -Filter 'Enabled -eq "True"' -Server $server -Credential $mojeHaslo -Properties LastLogonDate, AccountExpirationDate, PasswordLastSet, EmailAddress|
    Where-Object { $_.LastLogonDate -lt $dataGraniczna } |
    Select-Object Name, @{Name="Email"; Expression={$_.EmailAddress}}, LastLogonDate, AccountExpirationDate, PasswordLastSet |
    Export-Csv -Path $sciezka -NoTypeInformation -Encoding utf8 -Delimiter ";"


Write-Host "Raport został zapisany na pulpicie: $sciezka" -ForegroundColor Green
