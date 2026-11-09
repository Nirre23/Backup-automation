# Backup Automation

## Mål

Målet med projektet var att bygga en enkel lokal backup-lösning med hjälp av Terraform och PowerShell.

Terraform används för att skapa den mappstruktur som behövs, medan PowerShell sköter automatiseringen av testfiler och själva backupen genom att kopiera filer från en källmapp till en backupmapp.

Lösningen kontrollerar även att filerna har kopierats korrekt och hanterar fel som kan uppstå under körningen.

## Metod

### Terraform

Terraform används för att skapa mapparna `source` och `backups`.

Jag använder Local Provider och två resurser av typen `local_file`. Dessa skapar varsin tom `.keep`-fil i respektive mapp. På så sätt skapas mapparna automatiskt om de inte redan finns.

Mappen `terraform` innehåller filen `main.tf`, som innehåller provider-konfiguration, variabler, resurser och outputs.

Sökvägarna styrs av variabler, vilket gör dem enkla att ändra. Jag har även lagt till två outputs som visar sökvägarna till mapparna.

### PowerShell

PowerShell används för att automatisera körningen, skapa testfiler, genomföra backupen och kontrollera resultatet.

Backupskriptet:
- Kontrollerar att källmappen och backupmappen finns.
- Hämtar filerna från källmappen.
- Kopierar filerna till backupmappen med en tidsstämpel i filnamnet.
- Använder ett filprefix för att skilja backupfilerna från originalfilerna.
- Sparar namnen på de skapade filerna i en lista.
- Kontrollerar att backupfilerna finns på plats.
- Hanterar fel med hjälp av `try/catch`.

Jag har även skapat ett separat skript för testfiler. Det skapar automatiskt textfiler i källmappen med löpnummer, exempelvis `test_001.txt`, `test_002.txt` och så vidare. Varje fil får även innehåll med datum och klockslag för när den skapades.

### Konfigurationsfil

Projektet använder en gemensam `config.json` för inställningar som används av PowerShell-skripten.

Filen innehåller:
- `sourceFolder` – namnet på källmappen.
- `backupFolder` – namnet på backupmappen.
- `filePrefix` – prefix som används i backupfilernas namn.
- `timestampFormat` – formatet för datum och klockslag.

Det gör att vissa inställningar kan ändras på ett ställe i stället för direkt i skripten.

### Skriptstruktur

Projektet har fyra separata PowerShell-skript:

- `setup-folders.ps1` kör Terraform för att skapa den nödvändiga mappstrukturen.
- `create-testfile.ps1` skapar testfiler i källmappen med automatiska löpnummer.
- `backup.ps1` genomför själva kopieringen och verifieringen.
- `cleanup.ps1` raderar mapparna `source` och `backups` så att projektet kan nollställas. Skriptet frågar först och kräver att man skriver `yes` innan något tas bort.

Skripten har separata uppgifter, vilket gör att mappar kan skapas, testfiler genereras och backuper genomföras var för sig.

### Verktyg

- PowerShell 7
- Terraform
- WSL2 (Ubuntu)
- Visual Studio Code
- Git och GitHub

## Köra projektet

Öppna PowerShell i projektets huvudmapp.

**1. Skapa mappstrukturen**

```powershell
./scripts/setup-folders.ps1
```

Skriptet initierar Terraform och kör konfigurationen för att skapa mapparna.

**2. Skapa en testfil**

```powershell
./scripts/create-testfile.ps1
```

Skriptet skapar en textfil i `source`. Du kan även lägga egna filer där.

**3. Genomföra backupen**

```powershell
./scripts/backup.ps1
```

De skapade backupfilerna hamnar i `backups`. Varje fil får ett prefix och en tidsstämpel i filnamnet.

**4. Nollställa projektet**

```powershell
./scripts/cleanup.ps1
```

Skriptet kräver att du skriver `yes` för att bekräfta. Observera att både `source` och `backups` tas bort tillsammans med allt innehåll.

Efteråt kan du köra `setup-folders.ps1` igen för att skapa mapparna på nytt.

## Resultat

Resultatet blev en fungerande lokal backup-lösning där Terraform skapar mappstrukturen och PowerShell skapar testfiler, kopierar filer och verifierar resultatet.

Varje backupfil får ett prefix och en tidsstämpel i filnamnet, vilket gör att tidigare backuper finns kvar utan att skrivas över.

Jag har testat processen genom att ta bort mapparna och därefter återskapa dem med Terraform. Jag har också testat backupfunktionen med testfiler och kontrollerat att kopiorna skapas i rätt mapp.

Verifieringen kontrollerar att de skapade backupfilerna finns på plats.

Jag har även testat vad som händer när källmappen är tom. Då stannar skriptet och visar ett tydligt felmeddelande i stället för att skapa en tom backup.

## Reflektion

Under projektet har jag lärt mig hur Terraform och PowerShell kan samarbeta för att automatisera uppgifter som annars hade tagit tid att utföra manuellt.

I PowerShell fick jag en bättre förståelse för variabler, funktioner, loopar och felhantering. Särskilt felhanteringen tyckte jag var svår i början, men den blev tydligare ju mer jag använde den.

Med Terraform lärde jag mig att skapa och hantera filer och mappar på ett strukturerat sätt samt hur variabler kan användas för att göra konfigurationen enklare att ändra.

Om jag fortsatte utveckla projektet skulle jag vilja:

- **Lägga till stöd för undermappar**, så att hela mappstrukturer kan säkerhetskopieras och inte bara filer på en nivå.
- **Automatisera när backuperna körs**, så att man slipper starta dem själv varje gång.
- **Arkivera gamla backuper**, så att de inte tar onödig plats och det blir lättare att hålla ordning på dem.

## AI och externa källor

ChatGPT har använts som stöd under projektet för att få förklaringar, felsöka problem och diskutera kodens struktur och funktioner.

Jag har själv gått igenom, anpassat och testat koden för att förstå hur projektets olika delar fungerar. Jag ansvarar för den slutliga lösningen och dess funktion.

## GitHub

Länk till repo: [Backup Automation – GitHub](https://github.com/Nirre23/Backup-automation)
