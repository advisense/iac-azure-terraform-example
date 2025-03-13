const fs = require('fs');

function updateDocumentation(riskReportPath, advisoryPath, outputPath) {
    try {
        if (!fs.existsSync(riskReportPath)) {
            console.error(`Error: ${riskReportPath} not found!`);
            process.exit(1);
        }
        if (!fs.existsSync(advisoryPath)) {
            console.error(`Error: ${advisoryPath} not found!`);
            process.exit(1);
        }

        // Logikk for å oppdatere dokumentasjonen
        console.log('Updating documentation...');
        
        // Les innholdet fra risikorapporten og advisory-rapporten
        const riskReportContent = fs.readFileSync(riskReportPath, 'utf8');
        const advisoryContent = fs.readFileSync(advisoryPath, 'utf8');

        // Generer dokumentasjonsinnhold
        let documentationContent = `# Documentation Update\n\n**Generated at:** ${new Date().toISOString()}\n\n`;
        documentationContent += `## Risk Report\n\n${riskReportContent}\n\n`;
        documentationContent += `## Advisory Report\n\n${advisoryContent}\n\n`;

        // Skriv dokumentasjonen til en fil
        fs.writeFileSync(outputPath, documentationContent);
        console.log('Documentation updated successfully.');
    } catch (error) {
        console.error('Error updating documentation:', error);
    }
}

// Bruk filstier fra kommandolinjeargumenter
const riskReportPath = process.argv[2] || 'risk_report.md';
const advisoryPath = process.argv[3] || 'detailed_advisory.md';
const outputPath = process.argv[4] || 'documentation_update.md';
updateDocumentation(riskReportPath, advisoryPath, outputPath);