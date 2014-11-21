#!/bin/sh

set -e

ANSI_GREEN="\033[32m"
ANSI_RED="\033[31m"
ANSI_YELLOW="\033[33m"
ANSI_RESET="\033[0m"
ANSI_BOLD="\033[1m"

info () {
  echo "${ANSI_BOLD}${ANSI_BLUE}INFO:${ANSI_RESET} ${ANSI_BOLD}${@}${ANSI_RESET}" >&2
}

warn () {
  echo "${ANSI_BOLD}${ANSI_YELLOW}WARNING:${ANSI_RESET} ${ANSI_BOLD}${@}${ANSI_RESET}" >&2
}

error () {
  echo "${ANSI_RED}${ANSI_BOLD}ERROR:${ANSI_RESET} ${ANSI_RED}${@}${ANSI_RESET}" >&2
}

info "Installing development environment dependencies..."

if ! which vagrant > /dev/null 2>&1; then
    error "Vagrant not installed"
    error "Please download from http://www.vagrantup.com/downloads.html"
    exit 1
fi

if [ "$(uname -s)" != "Darwin" ]; then
    warn "This script is only tested on OSX, be warned!"
else
    if ! $(vagrant --help 2> /dev/null | grep dns > /dev/null); then
        info "Installing vagrant-dns"
        vagrant plugin install vagrant-dns > /dev/null 2>&1
        info "Installed vagrant-dns"
        info "Starting vagrant-dns - requires sudo"
    fi
    if vagrant dns --install > /dev/null 2>&1; then
        info "Started vagrant-dns"
    fi
fi

info "Development environment now bootstrapped."

IP_ADDRESS=$(grep ':ip ' Vagrantfile | head -n 1 | sed -e 's/.*:ip => "\(.*\)".*/\1/')

info "Your development IP will be $IP_ADDRESS"
info "Run \`vagrant up\` to begin."
