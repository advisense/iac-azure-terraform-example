const fs = require('fs');

// Sjekk at filen eksisterer
const filePath = process.argv[2];
if (!fs.existsSync(filePath)) {
  console.error(`File ${filePath} not found`);
  process.exit(1);
}

// Les filen
const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));

// Logg data-strukturen for å se hvordan den ser ut
console.log("Data structure:", data);

// Sjekk om data.Results er et array
if (Array.isArray(data.Results)) {
  data.Results.forEach(target => {
    console.log(`Target: ${target.Target}`);
    target.Vulnerabilities.forEach(vuln => {
      console.log(`Vulnerability ID: ${vuln.VulnerabilityID}`);
      console.log(`Severity: ${vuln.Severity}`);
      console.log(`Description: ${vuln.Description}`);
    });
  });
} else {
  console.error("Data.Results is not an array:", data.Results);
  process.exit(1);
}
