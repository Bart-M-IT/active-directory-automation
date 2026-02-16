# Przygotowanie zmiennych
$dzisiaj = Get-Date -Format "yyyy-MM-dd"
$dataGraniczna = (Get-Date).AddDays(-90)
$sciezka = "C:\Users\$env:USERNAME\Desktop\Raport_Hasla_$dzisiaj.csv"
$server = "dc01.contoso.local" # Podaj adres IP lub nazwę serwera 

# --- LOGOWANIE ---
if (-not $script:mojeHaslo) {
    $script:mojeHaslo = Get-Credential
}

# Pobieranie danych i audyt haseł
try {
    Write-Host "Rozpoczynam audyt haseł na serwerze: $server..." -ForegroundColor Cyan

    # Pobranie aktywnych kont z wygasającymi hasłami, które nie były zmieniane od 90 dni
    Get-ADUser -Filter 'Enabled -eq $true -and PasswordNeverExpires -eq $false -and PasswordLastSet -le $dataGraniczna' `
        -Server $server -Credential $mojeHaslo -Properties PasswordLastSet -ErrorAction Stop |
        Select-Object Name, PasswordLastSet, 
            @{Name="DniOdZmiany"; Expression={ ((Get-Date) - $_.PasswordLastSet).Days }} |
        Sort-Object DniOdZmiany -Descending |
        Export-Csv -Path $sciezka -NoTypeInformation -Encoding utf8 -Delimiter ";"

    Write-Host "Raport wygenerowany pomyślnie: $sciezka" -ForegroundColor Green
}
catch {
    Write-Host "BŁĄD: Nie udało się wygenerować raportu haseł." -ForegroundColor Red
    Write-Host "Szczegóły: $($_.Exception.Message)" -ForegroundColor Yellow
}
