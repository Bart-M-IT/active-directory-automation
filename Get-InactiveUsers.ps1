
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

# 2. Filtrowanie - Data ostatniego logowania, wygasanie konta, obsługa błędów
try {
    Write-Host "Rozpoczynam pobieranie danych z serwera: $server..." -ForegroundColor Cyan
    
    Get-ADUser -Filter 'Enabled -eq "True"' -Server $server -Credential $mojeHaslo `
        -Properties LastLogonDate, AccountExpirationDate, PasswordLastSet, EmailAddress `
        -ErrorAction Stop |
        Where-Object { $_.LastLogonDate -lt $dataGraniczna } |
        Select-Object Name, @{Name="Email"; Expression={$_.EmailAddress}}, LastLogonDate, AccountExpirationDate, PasswordLastSet |
        Export-Csv -Path $sciezka -NoTypeInformation -Encoding utf8 -Delimiter ";"
        
    Write-Host "Raport został pomyślnie zapisany: $sciezka" -ForegroundColor Green
}
catch {
    Write-Host "BŁĄD: Nie udało się wygenerować raportu." -ForegroundColor Red
    Write-Host "Szczegóły błędu: $($_.Exception.Message)" -ForegroundColor Yellow
}


