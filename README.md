# Active Directory Automation Toolkit 🛠️

Zbiór  skryptów PowerShell służących do automatyzacji administracji i audytu środowisk Active Directory.

## 📋 Skrypt: Get-InactiveUsers.ps1

### Problem
Ręczne weryfikowanie nieaktywnych kont użytkowników w dużych strukturach AD jest czasochłonne i podatne na błędy, co wpływa na bezpieczeństwo infrastruktury.

### Rozwiązanie
Skrypt automatycznie filtruje włączone konta użytkowników, którzy nie logowali się do domeny przez ostatnie 90 dni. 

### Kluczowe funkcjonalności:
* Wpełni bezpieczny dla AD - przedstawia tylko informację, bez modyfikacji kont. 
* Wyciąganie rozszerzonych właściwości (LastLogonDate, Email).
* Dynamiczne generowanie raportu do pliku CSV z datą w nazwie.
* Bezpieczne logowanie z wykorzystaniem `Get-Credential`.

## 📋 Skrypt: Get-ExpiredPasswordsReport.ps1

### Problem
Polityka wielu organizacji wymaga regularnej zmiany haseł.

### Rozwiązanie
Skrypt identyfikuje aktywne konta, które nie zmieniały hasła przez ostatnie 90 dni i generuje szczegółowy raport z wyliczoną liczbą dni od ostatniej zmiany.

### Kluczowe funkcjonalności:
* Filtrowanie kont bezpośrednio na serwerze (optymalizacja wydajności).
* Wyliczanie różnicy dat (atrybut dynamiczny `DniOdZmiany`).
* Pełna obsługa błędów i bezpieczne logowanie.
