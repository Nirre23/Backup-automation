# Backup Automation

## Mål

Målet med projektet var att bygga en enkel automatiserad backup-lösning med hjälp av Terraform och PowerShell.

Tanken är att Terraform ska skapa den mappstruktur som behövs, medan PowerShell sköter själva backupen genom att kopiera filer från en källmapp till en backupmapp.

Jag ville också att lösningen skulle kunna kontrollera att filerna har kopierats och hantera fel om något går fel under körningen.

## Så fungerar det

### Terraform

Terraform används för att skapa filer i mapparna `source` och `backups`, så att den nödvändiga mappstrukturen finns på plats.

I konfigurationen använder jag Local-providern, en variabel för projektnamnet och två resurser som skapar varsin `.keep`-fil.

### PowerShell

PowerShell används för att genomföra och kontrollera backupen.

Skriptet:
- Kontrollerar att källmappen och backupmappen finns.
- Hämtar filerna från källmappen.
- Kopierar filerna till backupmappen med en tidsstämpel i filnamnet.
- Sparar namnen på de skapade filerna i en lista.
- Kontrollerar att filerna från den senaste backupen finns på plats.
- Hanterar fel med hjälp av `try/catch`.

### Startskript

Jag har även skapat `run-backup.ps1`, som automatiserar hela processen.

Det startar först Terraform för att kontrollera och skapa den nödvändiga strukturen. Därefter startas PowerShell-skriptet som genomför och verifierar backupen.

## Köra projektet

För att starta hela processen öppnar man PowerShell i projektets huvudmapp och kör:

```powershell
./run-backup.ps1
```

## Resultat

Resultatet blev en fungerande backup-lösning där filer kopieras från källmappen till backupmappen.

Varje fil får en tidsstämpel i filnamnet, vilket gör att tidigare backuper finns kvar utan att skrivas över.

Jag har testat lösningen med flera filer och kontrollerat att kopiorna hamnar i rätt mapp. Jag har även testat vad som händer när källmappen saknas. Då upptäcker skriptet felet och visar ett tydligt felmeddelande.

## Reflektion

Under projektet har jag lärt mig mer om hur Terraform och PowerShell kan användas tillsammans för att automatisera uppgifter som annars hade behövt göras manuellt.

I PowerShell har jag fått bättre förståelse för variabler, funktioner, loopar och felhantering. Särskilt felhanteringen tyckte jag var krånglig i början, men den blev tydligare ju mer jag arbetade med den.

Med Terraform har jag lärt mig hur man kan beskriva och skapa en mappstruktur med hjälp av kod.

Om jag skulle fortsätta utveckla projektet skulle jag vilja lägga till stöd för undermappar, så att även filer i underliggande mappar kan säkerhetskopieras. Jag skulle också vilja automatisera körningen så att backuper skapas enligt ett schema. En annan förbättring vore att kunna rensa eller arkivera gamla backuper för att undvika att de tar upp onödigt mycket lagringsutrymme.

## Verktyg

- PowerShell 7
- Terraform
- WSL2 (Ubuntu)
- Git och GitHub

## GitHub

[Backup Automation – GitHub](https://github.com/Nirre23/Backup-automation)
