const fs = require('fs');

// Sjekk at filen risikovurdering eksisterer
const riskReportPath = process.argv[2];
if (!fs.existsSync(riskReportPath)) {
  console.error(`File ${riskReportPath} not found!`);
  process.exit(1);
}

// Les inn risikovurderingsrapporten
const riskReport = fs.readFileSync(riskReportPath, 'utf8');

// Generer en enkel rapport som eksempel
const advisoryReport = `
## Security Advisory

### Report generated at: ${new Date().toISOString()}

#### Risk Summary:
${riskReport}

#### Recommended Actions:
- Update vulnerable dependencies.
- Apply available patches or workarounds.
`;

// Skriv ut advisories-rapporten til konsollen (eller til en fil)
console.log(advisoryReport);

// Du kan også velge å skrive den til en fil om nødvendig
fs.writeFileSync('advisory.md', advisoryReport);

process.exit(0);
