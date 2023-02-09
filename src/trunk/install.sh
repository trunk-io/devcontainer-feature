#!/bin/sh

set -e

echo "Activating feature 'trunk'"

curl https://get.trunk.io -fsSL | bash
chmod o+r /usr/local/bin/trunk
