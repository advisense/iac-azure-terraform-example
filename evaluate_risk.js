const fs = require('fs');

// Assign a severity score based on vulnerability severity level
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

// Generate a risk report from the Trivy scan results
function generateRiskReport(trivyReportPath, outputPath) {
    try {
        // Read and parse the Trivy JSON report
        const rawData = fs.readFileSync(trivyReportPath, 'utf8');
        const report = JSON.parse(rawData);

        console.log('Parsed report:', report);

        // Extract vulnerabilities from the report (handle missing data)
        const vulnerabilities = report.Results ? report.Results.flatMap(result => result.Vulnerabilities || []) : [];

        console.log('Parsed vulnerabilities:', vulnerabilities);

        // Assign severity scores to vulnerabilities
        const evaluatedVulnerabilities = evaluateRisk(vulnerabilities);

        // Build the markdown report
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

// Implement temporary workarounds based on the risk report
function implementWorkarounds(riskReportPath) {
    try {
        console.log("Implementing temporary workarounds...");

        // Simulate a workaround, e.g., create a dummy config file if missing
        const dummyConfig = 'config.json';

        if (!fs.existsSync(dummyConfig)) {
            fs.writeFileSync(dummyConfig, JSON.stringify({ setting: "default" }, null, 2));
            console.log(`${dummyConfig} created with default settings.`);
        } else {
            console.log(`${dummyConfig} already exists.`);
        }

        // Read risk report content
        const riskReport = fs.readFileSync(riskReportPath, 'utf8');
        console.log('Risk report content:', riskReport);

        console.log("Workarounds applied successfully.");
    } catch (error) {
        console.error('Error implementing workarounds:', error);
    }
}

// Update documentation with risk report and advisory details
function updateDocumentation(riskReportPath, advisoryPath, outputPath) {
    try {
        // Check if required files exist
        if (!fs.existsSync(riskReportPath)) {
            console.error(`Error: ${riskReportPath} not found!`);
            process.exit(1);
        }
        if (!fs.existsSync(advisoryPath)) {
            console.error(`Error: ${advisoryPath} not found!`);
            process.exit(1);
        }

        console.log('Updating documentation...');

        // Read contents of the risk report and advisory report
        const riskReportContent = fs.readFileSync(riskReportPath, 'utf8');
        const advisoryContent = fs.readFileSync(advisoryPath, 'utf8');

        // Generate documentation content
        let documentationContent = `# Documentation Update\n\n**Generated at:** ${new Date().toISOString()}\n\n`;
        documentationContent += `## Risk Report\n\n${riskReportContent}\n\n`;
        documentationContent += `## Advisory Report\n\n${advisoryContent}\n\n`;

        // Write the updated documentation to a file
        fs.writeFileSync(outputPath, documentationContent);
        console.log('Documentation updated successfully.');
    } catch (error) {
        console.error('Error updating documentation:', error);
    }
}

// Read file paths from command-line arguments or use default values
const trivyReportPath = process.argv[2] || 'trivy-report.json';
const riskReportPath = process.argv[3] || 'risk_report.md';
const advisoryPath = process.argv[4] || 'detailed_advisory.md';
const documentationOutputPath = process.argv[5] || 'documentation_update.md';

// Generate the risk report
generateRiskReport(trivyReportPath, riskReportPath);

// Implement workarounds
implementWorkarounds(riskReportPath);

// Update documentation
updateDocumentation(riskReportPath, advisoryPath, documentationOutputPath);
