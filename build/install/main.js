const backgroundGenerator = require('./background/backgroundGenerator');

(async () => {
    await backgroundGenerator.generateSvgBackground();
})();