# Backup Automation

## Mål

Målet med projektet var att bygga en enkel lokal backup-lösning med hjälp av Terraform och PowerShell.

Terraform används för att skapa den mappstruktur som behövs, medan PowerShell sköter själva backupen genom att kopiera filer från en källmapp till en backupmapp.

Lösningen ska även kunna kontrollera att filerna har kopierats och hantera fel om något går fel under körningen.

## Metod

### Terraform

Terraform används för att skapa mapparna `source` och `backups`.

Jag använder Local-providern och två resurser av typen `local_file`. Dessa skapar varsin tom `.keep`-fil i respektive mapp. På så sätt skapas mapparna automatiskt om de saknas.

Sökvägarna till mapparna styrs av variabler, så de är enkla att ändra. Jag har även lagt till två outputs som visar sökvägarna till mapparna.

### PowerShell

PowerShell används för att genomföra och kontrollera backupen.

Backupskriptet:
- Kontrollerar att källmappen och backupmappen finns.
- Hämtar filerna från källmappen.
- Kopierar filerna till backupmappen med en tidsstämpel i filnamnet.
- Sparar namnen på de skapade filerna i en lista.
- Kontrollerar att de skapade backupfilerna finns på plats.
- Hanterar fel med hjälp av `try/catch`.

### Skriptstruktur

Projektet har två separata PowerShell-skript:

- `setup-folders.ps1` kör Terraform för att skapa den nödvändiga mappstrukturen.
- `backup.ps1` genomför själva kopieringen och verifieringen.

Skripten har separata uppgifter, vilket gör att mapparna kan skapas utan att en backup behöver genomföras varje gång.

### Verktyg

- PowerShell 7
- Terraform
- WSL2 (Ubuntu)
- Git och GitHub

## Köra projektet

Öppna PowerShell i projektets huvudmapp.

För att skapa mappstrukturen kör du:

```powershell
./scripts/setup-folders.ps1
```

Lägg sedan filer som ska säkerhetskopieras i `source`.

För att genomföra backupen kör du:

```powershell
./scripts/backup.ps1
```

De skapade backupfilerna hamnar i `backups`.

## Resultat

Resultatet blev en fungerande lokal backup-lösning där Terraform skapar mappstrukturen och PowerShell kopierar och verifierar filerna.

Varje backupfil får en tidsstämpel i filnamnet, vilket gör att tidigare backuper finns kvar utan att skrivas över.

Jag har testat hela processen genom att ta bort mapparna och därefter återskapa dem med Terraform. Jag har också testat backupfunktionen med testfiler och kontrollerat att kopiorna skapas i rätt mapp. Verifieringen kontrollerar att de skapade backupfilerna finns på plats.

## Reflektion

Under projektet har jag lärt mig hur Terraform och PowerShell kan samarbeta för att automatisera uppgifter som annars hade tagit mycket tid att göra manuellt.

I PowerShell fick jag en bättre förståelse för variabler, funktioner, loopar och felhantering. Särskilt felhanteringen tyckte jag var krånglig i början, men den blev tydligare ju mer jag använde den. Med Terraform lärde jag mig att skapa och hantera filer och mappar på ett strukturerat sätt.

Om jag fortsatte utveckla projektet skulle jag vilja:

- **Lägga till stöd för undermappar**, så att hela mappstrukturer kan säkerhetskopieras och inte bara filer på en nivå.
- **Automatisera när backuperna körs**, så att man slipper starta dem själv varje gång.
- **Arkivera gamla backuper**, så att de inte tar onödig plats och det blir lättare att hålla ordning på dem.

## GitHub

Länk till repo: [Backup Automation – GitHub](https://github.com/Nirre23/Backup-automation)
