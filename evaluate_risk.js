const fs = require('fs');

// Les trivy-rapporten
const rawData = fs.readFileSync('trivy-report.json');
const report = JSON.parse(rawData);

// Logg dataen for å se hva den inneholder
console.log('Parsed report:', report);

// Anta at sårbarhetene er i en array under en bestemt nøkkel
const vulnerabilities = report.Results ? report.Results.flatMap(result => result.Vulnerabilities || []) : [];

// Logg sårbarhetene for å bekrefte at de er en array
console.log('Parsed vulnerabilities:', vulnerabilities);

// Funksjon for å vurdere risiko
function evaluateRisk(vulnerabilities) {
    return vulnerabilities.map(vuln => {
        let severityScore;
        switch (vuln.Severity) {
            case 'CRITICAL':
                severityScore = 5;
                break;
            case 'HIGH':
                severityScore = 4;
                break;
            case 'MEDIUM':
                severityScore = 3;
                break;
            case 'LOW':
                severityScore = 2;
                break;
            default:
                severityScore = 1;
        }
        return {
            ...vuln,
            severityScore
        };
    });
}

// Vurder og prioriter sårbarhetene
const evaluatedVulnerabilities = evaluateRisk(vulnerabilities);

// Generer rapport
let reportContent = '# Risk Report\n\n';
evaluatedVulnerabilities.forEach(vuln => {
    reportContent += `## ${vuln.VulnerabilityID}\n`;
    reportContent += `- Severity: ${vuln.Severity}\n`;
    reportContent += `- Severity Score: ${vuln.severityScore}\n`;
    reportContent += `- Description: ${vuln.Description}\n\n`;
});

// Skriv rapporten til en fil
fs.writeFileSync('risk_report.md', reportContent);

console.log('Risk report generated successfully.');
