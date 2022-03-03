#!/bin/bash
set -eu

##
# Install ChromeDriver
#
# Keeps ChromeDriver installation up-to-date with the currently installed
# major version of Google Chrome.
#
# This script is idempotent. It will only install ChromeDriver if:
#   - ChromeDriver is not currently installed, or
#   - the currently installed major version does not match Google Chrome
#
# Note: this script *does not* perform minor version updates of ChromeDriver
##

# Major version of Google Chrome installed on the machine (e.g. 98)
chrome_version=$(google-chrome --version | grep -Po "(?<=\s)[0-9]+")

# Major version of ChromeDriver, if installed
is_installed () { command -v "$1" >/dev/null 2>&1; }
chromedriver_version=$( ! is_installed chromedriver || chromedriver --version | grep -Po "(?<=\s)[0-9]+" )

# Install ChromeDriver if it's missing or doesn't match the Google Chrome major version
if [ "$chrome_version" != "$chromedriver_version" ]; then

  # Create a unique temporary directory to work in
  workdir=$(mktemp -d)

  # Clean up after ourselves whenever the script exits
  # trap covers scenarios where "set -eu" causes us to exit early, as well as successful script completion
  trap 'rm -rf "$workdir"' EXIT

  # Find out which version of ChromeDriver is required for compatibility with the installed Chrome version
  required_version=$(curl "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$chrome_version")

  # Download & install ChromeDriver
  wget "https://chromedriver.storage.googleapis.com/$required_version/chromedriver_linux64.zip" -O "$workdir/chromedriver.zip"
  unzip "$workdir/chromedriver.zip" -d "$workdir/unzipped"
  mv "$workdir/unzipped/chromedriver" "/usr/local/bin/chromedriver"
  chmod +x "/usr/local/bin/chromedriver"
  echo "Installed $(chromedriver --version)"

fi
