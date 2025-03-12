const fs = require('fs');

function generateMarkdownReport(trivyReportPath, checkovReportPath) {
  const trivyData = JSON.parse(fs.readFileSync(trivyReportPath, 'utf8'));
  let checkovData;

  try {
    checkovData = JSON.parse(fs.readFileSync(checkovReportPath, 'utf8'));
  } catch (error) {
    console.error(`Error reading Checkov report: ${error.message}`);
    checkovData = { results: [], summary: {} };  // Fallback hvis Checkov-rapporten ikke kan leses
  }

  let markdown = `# Security Advisory Report\n\n**Report generated at:** ${new Date().toISOString()}\n\n## Risk Summary\n\n`;

  // Trivy Results
  markdown += `### Trivy Results\n`;
  trivyData.Results.forEach(result => {
    markdown += `#### Target: ${result.Target}\n`;
    markdown += `- **Class:** ${result.Class}\n`;
    markdown += `- **Type:** ${result.Type}\n`;
    if (result.MisconfSummary) {
      markdown += `- **Successes:** ${result.MisconfSummary.Successes}\n`;
      markdown += `- **Failures:** ${result.MisconfSummary.Failures}\n`;
    }
    if (result.Misconfigurations) {
      result.Misconfigurations.forEach(misconf => {
        markdown += `\n##### Misconfiguration: ${misconf.Title}\n`;
        markdown += `- **Description:** ${misconf.Description}\n`;
        markdown += `- **Message:** ${misconf.Message}\n`;
        markdown += `- **Severity:** ${misconf.Severity}\n`;
        markdown += `- **Resolution:** ${misconf.Resolution}\n`;
        markdown += `- **References:**\n`;
        misconf.References.forEach(ref => {
          markdown += `  - ${ref}\n`;
        });
      });
    }
    markdown += '\n';
  });

  // Checkov Results
  markdown += `### Checkov Results\n`;
  if (checkovData.results && checkovData.results.length > 0) {
    checkovData.results.forEach(result => {
      markdown += `#### File: ${result.file_path}\n`;
      markdown += `- **Check ID:** ${result.check_id}\n`;
      markdown += `- **Severity:** ${result.severity}\n`;
      markdown += `- **Description:** ${result.description}\n`;
      markdown += `- **Resource:** ${result.resource}\n`;
      markdown += `- **Line:** ${result.file_line_range.join('-')}\n\n`;
    });
  } else {
    markdown += `No Checkov results found.\n\n`;
  }

  // Add Checkov Summary
  markdown += `### Checkov Summary\n`;
  markdown += `- **Passed checks:** ${checkovData.summary?.passed || 0}\n`;
  markdown += `- **Failed checks:** ${checkovData.summary?.failed || 0}\n`;
  markdown += `- **Skipped checks:** ${checkovData.summary?.skipped || 0}\n`;
  markdown += `- **Parsing errors:** ${checkovData.summary?.parsing_errors || 0}\n`;

  markdown += `## Recommended Actions\n- Update vulnerable dependencies.\n- Apply available patches or workarounds.\n`;

  return markdown;
}

const trivyReportPath = process.argv[2];
const checkovReportPath = process.argv[3];
const outputPath = process.argv[4] || 'detailed_advisory.md';

// Validate arguments
if (!trivyReportPath || !checkovReportPath) {
  console.error('Error: Missing required arguments.');
  process.exit(1);
}

const output = generateMarkdownReport(trivyReportPath, checkovReportPath);
fs.writeFileSync(outputPath, output);  // Save as detailed_advisory.md
console.log('Advisory report generated successfully.');
