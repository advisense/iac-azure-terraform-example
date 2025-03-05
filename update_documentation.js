const fs = require("fs");
const path = require("path");

const riskReportPath = "risk_report.md";
const advisoryPath = "advisory.md";
const documentationPath = "SECURITY.md"; // Endre dette hvis du vil oppdatere en annen dokumentasjon

console.log("Updating documentation...");

// Sjekk om nødvendige filer finnes
if (!fs.existsSync(riskReportPath) || !fs.existsSync(advisoryPath)) {
  console.error("Error: Required input files not found!");
  process.exit(1);
}

// Les innhold fra risk_report.md og advisory.md
const riskReport = fs.readFileSync(riskReportPath, "utf8");
const advisory = fs.readFileSync(advisoryPath, "utf8");

// Opprett eller oppdater dokumentasjonen
let newContent = `# Security Documentation\n\n`;
newContent += `## Latest Risk Assessment\n${riskReport}\n\n`;
newContent += `## Security Advisory\n${advisory}\n\n`;

if (fs.existsSync(documentationPath)) {
  console.log("Updating existing documentation...");
  fs.appendFileSync(documentationPath, newContent);
} else {
  console.log("Creating new documentation file...");
  fs.writeFileSync(documentationPath, newContent);
}

console.log("Documentation updated successfully!");
