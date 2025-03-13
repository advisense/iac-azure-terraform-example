const fs = require('fs');

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

function generateRiskReport(trivyReportPath, outputPath) {
    try {
        // Les trivy-rapporten
        const rawData = fs.readFileSync(trivyReportPath, 'utf8');
        const report = JSON.parse(rawData);

        // Logg dataen for å se hva den inneholder
        console.log('Parsed report:', report);

        // Anta at sårbarhetene er i en array under en bestemt nøkkel
        const vulnerabilities = report.Results ? report.Results.flatMap(result => result.Vulnerabilities || []) : [];

        // Logg sårbarhetene for å bekrefte at de er en array
        console.log('Parsed vulnerabilities:', vulnerabilities);

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
        fs.writeFileSync(outputPath, reportContent);
        console.log('Risk report generated successfully.');
    } catch (error) {
        console.error('Error generating risk report:', error);
    }
}

// Bruk filstier fra kommandolinjeargumenter
const trivyReportPath = process.argv[2] || 'trivy-report.json';
const outputPath = process.argv[3] || 'risk_report.md';
generateRiskReport(trivyReportPath, outputPath);