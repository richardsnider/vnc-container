module.exports = [
    {
        command: `uname -a`,
        comment: `# Get the kernel version`
    },
    {
        command: `lsb_release -a`,
        comment: `# Full release info of any LSB distribution`
    },
    {
        command: `cat /etc/SuSE-release`,
        comment: `# Get SuSE version`
    },
    {
        command: `cat /etc/debian_version`,
        comment: `# Get Debian version`
    },
    {
        command: `uptime`,
        comment: `# Show how long the system has been running + load`
    },
    {
        command: `hostname`,
        comment: `# system's host name`
    },
    {
        command: `hostname -i`,
        comment: `# Display the IP address of the host. (Linux only)`
    },
    {
        command: `man hier`,
        comment: `# Description of the file system hierarchy`
    },
    {
        command: `last reboot`,
        comment: `# Show system reboot history`
    },
    {
        command: `dmesg`,
        comment: `# Detected hardware and boot messages`
    },
    {
        command: `lsdev`,
        comment: `# information about installed hardware`
    },
    {
        command: `cat /proc/cpuinfo`,
        comment: `# CPU model`
    },
    {
        command: `cat /proc/meminfo`,
        comment: `# Hardware memory`
    },
    {
        command: `grep MemTotal /proc/meminfo`,
        comment: `# Display the physical memory`
    },
    {
        command: `watch -n1 'cat /proc/interrupts'`,
        comment: `# Watch changeable interrupts continuously`
    },
    {
        command: `free -m`,
        comment: `# Used and free memory (-m for MB)`
    },
    {
        command: `cat /proc/devices`,
        comment: `# Configured devices`
    },
    {
        command: `lspci -tv`,
        comment: `# Show PCI devices`
    },
    {
        command: `lsusb -tv`,
        comment: `# Show USB devices`
    },
    {
        command: `lshal`,
        comment: `# Show a list of all devices with their properties`
    },
    {
        command: `dmidecode`,
        comment: `# Show DMI/SMBIOS: hw info from the BIOS`
    },
    {
        command: `top`,
        comment: `# display and update the top cpu processes`
    },
    {
        command: `mpstat 1`,
        comment: `# display processors related statistics`
    },
    {
        command: `vmstat 2`,
        comment: `# display virtual memory statistics`
    },
    {
        command: `iostat 2`,
        comment: `# display I/O statistics (2 s intervals)`
    },
    {
        command: `systat -vmstat 1`,
        comment: `# BSD summary of system statistics (1 s intervals)`
    },
    {
        command: `systat -tcp 1`,
        comment: `# BSD tcp connections (try also -ip)`
    },
    {
        command: `systat -netstat 1`,
        comment: `# BSD active network connections`
    },
    {
        command: `systat -ifstat 1`,
        comment: `# BSD network traffic through active interfaces`
    },
    {
        command: `systat -iostat 1`,
        comment: `# BSD CPU and and disk throughput`
    },
    {
        command: `ipcs -a`,
        comment: `# information on System V interprocess`
    },
    {
        command: `tail -n 500 /var/log/messages`,
        comment: `# Last 500 kernel/syslog messages`
    },
    {
        command: `tail /var/log/warn`,
        comment: `# System warnings messages see syslog.conf`
    },
    {
        command: `id`,
        comment: `# Show the active user id with login and group`
    },
    {
        command: `last`,
        comment: `# Show last logins on the system`
    },
    {
        command: `who`,
        comment: `# Show who is logged on the system`
    },
    // {
    //     command: `usermod -a -G \<group\> \<user\>`,
    //     comment: `# Add existing user to group (Debian)`
    // },
    // {
    //     command: `groupmod -A \<user\> \<group\>`,
    //     comment: `# Add existing user to group (SuSE)`
    // },
    {
        command: `userdel colin`,
        comment: `# Delete user colin (Linux/Solaris)`
    },
    {
        command: `adduser joe`,
        comment: `# FreeBSD add user joe (interactive)`
    },
    {
        command: `rmuser joe`,
        comment: `# FreeBSD delete user joe (interactive)`
    },
    {
        command: `pw groupadd admin`,
        comment: `# Use pw on FreeBSD`
    },
    {
        command: `pw groupmod admin -m newmember`,
        comment: `# Add a new member to a group`
    },
    {
        command: `git config --global user.name "John Doe"`,
        comment: `# Set git username`
    },
    {
        command: `git config --global user.email jdoe@example.com`,
        comment: `# Set git email address`
    },
    {
        command: `npm adduser --registry=https://registry.npmjs.org --scope=@myco`,
        comment: `# Login to npm`
    },
    {
        command: `npm publish --access public`,
        comment: `# Publish scoped package`
    }
]