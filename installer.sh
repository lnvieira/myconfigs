#!/bin/sh
inittime=$(date +%s)

echo "Running installer"


###
# Storing script directory
###
current_dir=$(pwd)
script_dir=$(dirname $0)

if [ $script_dir = '.' ]; then
	script_dir="$current_dir"
fi

backToScriptDir(){
	cd "$script_dir"
}

verifyCommandExistence(){
	return $(which $1 >/dev/null)
}


###
# Sublime installing
###
if verifyCommandExistence subl; then
	echo "Sublime is already installed."
else
	cd ~/Downloads
	wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb
	sudo dpkg -i sublime-text_build-3083_amd64.deb
	wget https://sublime.wbond.net/Package%20Control.sublime-package
	cp Package\ Control.sublime-package ~/.config/sublime-text-3/Installed\ Packages
	echo "Sublime Text installed."
fi


###
# Copying Sublime settings
###
backToScriptDir
cp Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User/
cp Preferences.sublime-settings ~/.config/sublime-text-3/Packages/User/
echo "Sublime asks for restarting itself for installing everything ¯\_(ツ)_/¯."


###
# Node installing
###
if verifyCommandExistence node; then
	echo "NodeJS is already installed."
else
	cd ~/Downloads
	wget https://nodejs.org/dist/v4.2.0/node-v4.2.0-linux-x64.tar.gz
	tar xvzf node-v4.2.0-linux-x64.tar.gz
	sudo cp -rp node-v4.2.0-linux-x64 /usr/local/
	sudo mv /usr/local/node-v4.2.0-linux-x64 /usr/local/node_v420
	sudo ln -s /usr/local/node_v420/bin/node /usr/local/bin/node
	sudo ln -s /usr/local/node_v420/bin/npm /usr/local/bin/npm
	echo "NodeJS 4.0.2 installed."
fi


###
# Grunt and bower installing
###
echo "Installing Grunt."
sudo npm install -g grunt-cli
echo "Grunt installed."
echo "Installing Bower."
sudo npm install -g bower
echo "Bower installed."


###
# Copying bash scripts session
###
backToScriptDir
if [ -f ~/.bash_aliases ]; then
	cp ~/.bash_aliases ~/.bash_aliases__bkp
fi

cp ~/.bashrc ~/.bashrc__bkp
echo "Your bashrc was backed up at ~/.bashrc__bkp ."
cp .bashrc ~
echo "Your bashrc updated."
cp .bash_aliases ~
echo "Your bash_aliases updated."

. ~/.bashrc
echo "Your bashrc executed."

finaltime=$(date +%s)
t=$(($finaltime-$inittime))

echo "Time spent: $t ms"


###
# Last warnings
###
echo "As shellscript runs on another instance of bash, you have to restart your terminal to use new configs."
