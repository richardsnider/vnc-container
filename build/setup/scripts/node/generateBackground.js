const util = require('util');
const fs = require('fs');

const writeFile = util.promisify(fs.writeFile);
const backgroundGenerator = require('./background/backgroundGenerator');

(async () => {
    const svgData = await backgroundGenerator.generateSvgBackground();
    await writeFile(`./background.svg`, svgData);
})();