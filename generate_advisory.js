const fs = require('fs');

function generateMarkdownReport(trivyReport, checkovReport, checkovSummary) {
  const trivyData = JSON.parse(fs.readFileSync(trivyReport, 'utf8'));
  let checkovData;

  try {
    checkovData = JSON.parse(fs.readFileSync(checkovReport, 'utf8'));
  } catch (error) {
    console.error(`Error reading Checkov report: ${error.message}`);
    checkovData = { results: [] };  // Fallback to empty results
  }

  let markdown = `# Security Advisory Report\n\n**Report generated at:** ${new Date().toISOString()}\n\n## Risk Summary\n\n`;

  // Include Trivy results
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

  // Include Checkov results
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

  // Include Checkov summary
  markdown += `### Checkov Summary\n`;
  markdown += fs.readFileSync(checkovSummary, 'utf8');

  markdown += `## Recommended Actions\n- Update vulnerable dependencies.\n- Apply available patches or workarounds.\n`;

  return markdown;
}

const trivyReport = process.argv[2];
const checkovReport = process.argv[3];
console.log('Advisory report generated successfully.');