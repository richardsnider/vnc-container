const childProcess = require('child_process');
const util = require('util');

const execute = util.promisify(childProcess.exec);

module.exports = async (command) => {
    console.log(command);
    const result = await execute(command);
    console.log(result.stdout);
    console.log(result.stderr);
    return result;
};