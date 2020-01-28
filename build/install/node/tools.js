const exec = require('./utilities/exec');

const cleanup = async () => {
    exec(`rm -rf ~/Music`);
    exec(`rm -rf ~/Pictures`);
    exec(`rm -rf ~/Videos`);
    exec(`rm -rf ~/Documents`);
    exec(`rm -rf ~/Templates`);
    exec(`mkdir ~/git`);
};

const generateSSH = async (email) => {
    exec(`ssh-keygen -t rsa -b 4096 ${email ? `"-C ${email}"` : ``}`);
}

const setSSH = async (sshKeyName) => {
    exec(`eval "$(ssh-agent -s)"`);
    exec(`ssh-add ~/.ssh/${sshKeyName || `id_rsa`}`);
}

(async () => {
    let argument = process.argv[2];

    argument === cleanup.name ? cleanup() :
    argument === generateSSH.name ? generateSSH(process.argv[3]) :
    argument === setSSH.name ? setSSH(process.argv[3]) :
    console.log(`"${argument}" not recognized.`);
})();