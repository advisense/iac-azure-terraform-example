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
       // Read the Trivy report
        const rawData = fs.readFileSync(trivyReportPath, 'utf8');
        const report = JSON.parse(rawData);

        // Log the parsed report to confirm it was read successfully
        console.log('Parsed report:', report);

        // Extract vulnerabilities from the report
        const vulnerabilities = report.Results ? report.Results.flatMap(result => result.Vulnerabilities || []) : [];

        // Log the parsed vulnerabilities to confirm they were extracted successfully
        console.log('Parsed vulnerabilities:', vulnerabilities);

        // Evaluate the risk of each vulnerability
        const evaluatedVulnerabilities = evaluateRisk(vulnerabilities);

        // Generate a risk report
        let reportContent = '# Risk Report\n\n';
        evaluatedVulnerabilities.forEach(vuln => {
            reportContent += `## ${vuln.VulnerabilityID}\n`;
            reportContent += `- Severity: ${vuln.Severity}\n`;
            reportContent += `- Severity Score: ${vuln.severityScore}\n`;
            reportContent += `- Description: ${vuln.Description}\n\n`;
        });

        // Write the risk report to a file
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