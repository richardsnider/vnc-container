const util = require('util');
const os = require('os');
const fs = require('fs');
const jsdom = require('jsdom');
const cliCommands = require('./cliCommands');
const _ = require('lodash');

const writeFile = util.promisify(fs.writeFile);

const document = new jsdom.JSDOM(``).window.document;

const svgHeader = `<svg height="1080pt" width="1920pt" xmlns="http://www.w3.org/2000/svg">`;
const svgStyling = `<style>
text {
    fill: white;
    font-size: 12;
    font-family: monospace;
}

.comment {
    fill: green
}
</style>`;
const svgBackgroundRect = `<rect width="100%" height="100%" fill="black" />`;
const svgClosingTag = `</svg>`;

const generateText = async () => {
    const xColumns = [ 100, 700, 1300 ];
    let xIterator = 0;
    let yCoordinate = 50;

    let context = document.createElement('canvas').getContext(`2d`);
    context.font = "12px Monospace";

    const xSeparatorPixels = 20;
    const ySeparatorPixels = 20;

    let textElements = ``;

    _.map(cliCommands, command => {
        let commandLength = context.measureText(command.command).width;

        let commandTextElement = `<text x="${xColumns[xIterator]}" y="${yCoordinate}">${command.command}</text>`;
        let commentTextElement = `<text x="${xColumns[xIterator] + commandLength + xSeparatorPixels}" y="${yCoordinate}" class="comment">${command.comment}</text>`;
        textElements += `\n${commandTextElement}${commentTextElement}`;

        if(xIterator === 2) {
            xIterator = 0;
            yCoordinate += ySeparatorPixels;
        } else xIterator++;
    });

    return textElements;
}

module.exports = {
    generateSvgBackground: async () => {
        const textElements = await generateText();
        const svgData = svgHeader + svgStyling + svgBackgroundRect + textElements + svgClosingTag;
        await writeFile(`${os.homedir()}/background.svg`, svgData);
    }
}