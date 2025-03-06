const fs = require('fs');

// Read trivy report
const rawData = fs.readFileSync('trivy-report.json');
const report = JSON.parse(rawData);

// Log data to confirm it was parsed correctly
console.log('Parsed report:', report);

// Extract vulnerabilities from the report
const vulnerabilities = report.Results ? report.Results.flatMap(result => result.Vulnerabilities || []) : [];

// Log the parsed vulnerabilities
console.log('Parsed vulnerabilities:', vulnerabilities);

// Function to evaluate the risk of each vulnerability
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

// Evaluate and score the vulnerabilities
const evaluatedVulnerabilities = evaluateRisk(vulnerabilities);

// Generate a risk report
let reportContent = '# Risk Report\n\n';
evaluatedVulnerabilities.forEach(vuln => {
    reportContent += `## ${vuln.VulnerabilityID}\n`;
    reportContent += `- Severity: ${vuln.Severity}\n`;
    reportContent += `- Severity Score: ${vuln.severityScore}\n`;
    reportContent += `- Description: ${vuln.Description}\n\n`;
});

// Write report to file
fs.writeFileSync('risk_report.md', reportContent);

console.log('Risk report generated successfully.');