const fs = require('fs');

function generateMarkdownReport(trivyReportPath, checkovReportPath) {
  let trivyData;
  let checkovData;

  try {
    trivyData = JSON.parse(fs.readFileSync(trivyReportPath, 'utf8'));
  } catch (error) {
    console.error(`Error reading Trivy report: ${error.message}`);
    trivyData = { Results: [] };  // Fallback hvis Trivy-rapporten ikke kan leses
  }

  try {
    checkovData = JSON.parse(fs.readFileSync(checkovReportPath, 'utf8'));
  } catch (error) {
    console.error(`Error reading Checkov report: ${error.message}`);
    checkovData = { results: [], summary: {} };  // Fallback hvis Checkov-rapporten ikke kan leses
  }

  let markdown = `# Security Advisory Report\n\n**Report generated at:** ${new Date().toISOString()}\n\n## Risk Summary\n\n`;

  // === Trivy Results ===
  markdown += `## Trivy Results\n`;
  if (trivyData.Results && trivyData.Results.length > 0) {
    trivyData.Results.forEach(result => {
      markdown += `### Target: ${result.Target}\n`;
      markdown += `- **Class:** ${result.Class}\n`;
      markdown += `- **Type:** ${result.Type}\n`;

      if (result.Vulnerabilities && result.Vulnerabilities.length > 0) {
        result.Vulnerabilities.forEach(vuln => {
          markdown += `\n#### Vulnerability: ${vuln.VulnerabilityID}\n`;
          markdown += `- **Package:** ${vuln.PkgName} (${vuln.InstalledVersion})\n`;
          markdown += `- **Fixed Version:** ${vuln.FixedVersion || 'None'}\n`;
          markdown += `- **Severity:** ${vuln.Severity}\n`;
          markdown += `- **Description:** ${vuln.Description}\n`;
          markdown += `- **References:**\n`;
          vuln.References.forEach(ref => {
            markdown += `  - ${ref}\n`;
          });
        });
      } else {
        markdown += `- No vulnerabilities found.\n`;
      }
    });
  } else {
    markdown += `No Trivy results found.\n\n`;
  }

  // === Checkov Results === (Kun én gang)
  markdown += `## Checkov Results\n`;
  if (checkovData.results && checkovData.results.length > 0) {
    const filesChecked = new Set();

    checkovData.results.forEach(result => {
      filesChecked.add(result.file_path);
    });

    markdown += `**Total files analyzed by Checkov: ${filesChecked.size}**\n\n`;
  } else {
    markdown += `No Checkov results found.\n\n`;
  }

  // === Checkov Summary (Kun én gang) ===
  markdown += `## Checkov Summary\n`;
  markdown += `- **Passed checks:** ${checkovData.summary?.passed || 0}\n`;
  markdown += `- **Failed checks:** ${checkovData.summary?.failed || 0}\n`;
  markdown += `- **Skipped checks:** ${checkovData.summary?.skipped || 0}\n`;
  markdown += `- **Parsing errors:** ${checkovData.summary?.parsing_errors || 0}\n\n`;

  // === Recommended Actions === (Uten Checkov-resultatene)
  markdown += `## Recommended Actions\n`;
  markdown += `- Update vulnerable dependencies.\n`;
  markdown += `- Apply available patches or workarounds.\n`;

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
