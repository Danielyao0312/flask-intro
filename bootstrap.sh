#!/usr/bin/env bash

function install_packages {
    declare -a package_array=("${!1}")
    apt-get install -y ${package_array[@]}
}

# Install a global NPM package *only* if it hasn't already been
# installed.
function npm_install {
    local package="$1"

    if ! `npm list -g "$package" &> /dev/null`
    then
        npm install -g "$package"
    fi
}

# Install the packages passed to this function using `apt-get`, making sure
# not to require any user input.
function apt_install {
    apt-get install -y $*
}

echo "Start installing..."
apt-get update

apt_install build-essential
apt_install python-pip
apt_install python-dev

echo "Install nodejs 0.10..."
apt_install python-software-properties
apt-add-repository ppa:chris-lea/node.js
apt-get update
apt_install nodejs
npm install npm -g

echo "Install Less..."
npm install -g less
npm install -g less-watch-compiler

echo "Install MySQL..."
# These variables need to be set before MySQL is installed.
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'

mysql_packages=(
    mysql-server-5.5
    mysql-client
    libmysqlclient-dev
)

install_packages mysql_packages[@]


echo "Install python packages..."
(
    cd /vagrant
    pip install --upgrade -r requirements.txt
)

# echo "Install npm packages"
# (
#     cd /vagrant
#     npm install
# )

