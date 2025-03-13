const fs = require('fs');

function updateDocumentation(trivyReport, advisoryReport) {
  if (!fs.existsSync(trivyReport)) {
    console.error(`Error: ${trivyReport} not found!`);
    process.exit(1);
  }
  if (!fs.existsSync(advisoryReport)) {
    console.error(`Error: ${advisoryReport} not found!`);
    process.exit(1);
  }

  // Logic to update documentation
  console.log('Updating documentation...');
  // Example: Append advisory report to documentation
  const advisoryContent = fs.readFileSync(advisoryReport, 'utf8');
  fs.appendFileSync('documentation.md', advisoryContent);
  console.log('Documentation updated successfully.');
}

const trivyReport = process.argv[2];
const advisoryReport = process.argv[3];
updateDocumentation(trivyReport, advisoryReport);
