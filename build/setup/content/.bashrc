#!/bin/bash
unset VNC_PW

PS1='[$(date +"%y-%m-%d %H:%M:%S")]$'

# Set current user in nss_wrapper
USER_ID=$(id -u)
GROUP_ID=$(id -g)


eval $($HOME/.linuxbrew/bin/brew shellenv)

alias b-who='echo "user: $(whoami)" &&
    echo "directory: $(pwd)" &&
    echo "machine: $(uname -n)" &&
    echo "operating system: $(uname -rs)" &&
    echo "architecture: $(uname -m)" &&
    echo "time: $(date)"'

# Show folder contents
alias b-ls='echo "Dir Size|Perms|Link Count|Owner|Group|Size|Mod. Time|Name"; ls -AFhls --color --group-directories-first'

# Remove unnecessary folders
alias b-cleanup='rm -rf ~/Music ~/Pictures ~/Videos ~/Templates ~/Public ~/Documents'

# Search running processes
alias b-ps="ps -aux | grep "
alias b-top="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias b-find="find . | grep "

# Count all files (recursively) in the current folder
alias b-filecount="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias b-commandtype="type -t"

# Show current network connections to the server
alias b-connections="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"

# Show open ports
alias b-ports='netstat -nape --inet'

# Show ip interaction history
alias b-iptables='iptables -I INPUT -p tcp --dport 80 -j LOG && less +G --force /var/log/messages'

# Alias's to show disk space and space used in a folder
alias b-diskspace="du -S | sort -n -r |more"
alias b-folders='du -h --max-depth=1'
alias b-folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias b-tree='tree -CAhF --dirsfirst'
alias b-treed='tree -CAFd'
alias b-mountedinfo='df -hT'

# Alias's for archives
alias b-mktar='tar -cvf'
alias b-mkbz2='tar -cvjf'
alias b-mkgz='tar -cvzf'
alias b-untar='tar -xvf'
alias b-unbz2='tar -xvjf'
alias b-ungz='tar -xvzf'

# Show all logs in /var/log
alias b-logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# Searches for text in all files in the current folder
b-textsearch ()
{
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Show current network information
b-netinfo ()
{
	echo "--------------- Network Information ---------------"
	/sbin/ifconfig | awk /'inet addr/ {print $2}'
	echo ""
	/sbin/ifconfig | awk /'Bcast/ {print $3}'
	echo ""
	/sbin/ifconfig | awk /'inet addr/ {print $4}'

	/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
	echo "---------------------------------------------------"
}

b-ip ()
{
	# Dumps a list of all IP addresses for every device
	# /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';

	# Internal IP Lookup
	echo -n "Internal IP: " ; /sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

	# External IP Lookup
	echo -n "External IP: " ; wget http://smart-ip.net/myip -O - -q
}


alias b-git-findcommit='!git log --oneline --date=short --pretty=format:"%Cred%<(10)%h%Creset%Cgreen%<(20)%an%Creset%Cblue%<(15)%ad%Creset%<(20)%s" --source --all -S'
alias b-git-fc='!git log --oneline --date=short --pretty=format:"%Cred%<(10)%h%Creset%Cgreen%<(20)%an%Creset%Cblue%<(15)%ad%Creset%<(20)%s" --source --all -S'
alias b-git-hist='log --graph --oneline --decorate --all'
alias b-git-ls='log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'
alias b-git-ll='log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
alias b-git-la='"!git config -l | grep alias | cut -c 7-"'
alias b-git-rekt='reset --hard'
 
b-git-setup ()
{
	echo "GIT_USERNAME:"
	read GIT_USERNAME
	git config --global user.name $GIT_USERNAME
	echo "GIT_EMAIL:"
	read GIT_EMAIL
	git config --global user.email $GIT_EMAIL
	generate-ssh-key () {
		ssh-keygen -t rsa -b 4096 -q -N "" -f $HOME/.ssh/id_rsa
	}
	set-ssh-key () {
		echo "PRIVATE_SSH_KEY:"
		read -s PRIVATE_SSH_KEY
		echo $PRIVATE_SSH_KEY >> $HOME/.ssh/id_rsa
		echo "PUBLIC_SSH_KEY:"
		read -s PUBLIC_SSH_KEY
		echo $PUBLIC_SSH_KEY >> $HOME/.ssh/id_rsa.pub
	}
	echo "Generate new ssh key? [ y/N ]:"
	read GENERATE_SSH_KEY_DECISION
	if [[ "$GENERATE_SSH_KEY_DECISION" = "y" || "$GENERATE_SSH_KEY_DECISION" = "yes" || "$GENERATE_SSH_KEY_DECISION" = "Y" ]];
	then generate-ssh-key
	else set-ssh-key
	fi
	cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
	echo "Host github.com" >> $HOME/.ssh/config
	echo "User git" >> $HOME/.ssh/config
	echo "Hostname github.com" >> $HOME/.ssh/config
	echo "PreferredAuthentications publickey" >> $HOME/.ssh/config
	echo "IdentityFile $HOME/.ssh/id_rsa" >> $HOME/.ssh/config
	eval "$(ssh-agent -s)"
	ssh-add $HOME/.ssh/id_rsa
	chmod --recursive 700 $HOME/.ssh
	chown --recursive 1000 $HOME/.ssh
	mkdir ~/git
	cd ~/git
	echo "Enter a comma separated list of repository urls you wish to clone: "
	read GIT_REPOSITORIES
	# iterate through comma separated list and git clone for each
	for i in $(echo $GIT_REPOSITORIES | sed "s/,/ /g")
	do
		git clone $i
	done
	echo "NPM_ORG_NAME"
	read NPM_ORG_NAME
	npm adduser --registry=https://registry.npmjs.org --scope=@$NPM_ORG_NAME
}