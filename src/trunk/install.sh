#!/bin/sh

set -e

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            echo "Running apt-get update..."
            apt-get update -y
        fi
        apt-get -y install "$@"
    fi
}

echo "Activating feature 'trunk'"

check_packages curl
curl https://get.trunk.io -fsSL | bash
chmod o+r /usr/local/bin/trunk
