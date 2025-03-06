const fs = require('fs');

// Check if file risk assesment exists
const riskReportPath = process.argv[2];
if (!fs.existsSync(riskReportPath)) {
  console.error(`File ${riskReportPath} not found!`);
  process.exit(1);
}

// Read risk assesment rapport
const riskReport = fs.readFileSync(riskReportPath, 'utf8');

// Generate advisory report
const advisoryReport = `
## Security Advisory

### Report generated at: ${new Date().toISOString()}

#### Risk Summary:
${riskReport}

#### Recommended Actions:
- Update vulnerable dependencies.
- Apply available patches or workarounds.
`;

// Write advisory report to file
console.log(advisoryReport);

fs.writeFileSync('advisory.md', advisoryReport);

process.exit(0);
