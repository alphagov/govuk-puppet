#!/bin/sh

GOVUK_GITHUB_PUBLIC="git@github.com:alphagov"
GOVUK_GITHUB_ENT="git@github.gds:gds"
GOVUK_DEV_DOMAIN="dev.gov.uk"

GEM_VERSION_DAEMONS="1.1.8"
GEM_VERSION_RUBYDNS="0.4.1" # rubydns 0.5.x won't work with vagrantdns
GEM_VERSION_VAGRANT="1.0.5"
GEM_VERSION_VAGRANTDNS="0.2.4"

##############################################################################

set -e

ANSI_GREEN="\033[32m"
ANSI_RED="\033[31m"
ANSI_YELLOW="\033[33m"
ANSI_RESET="\033[0m"
ANSI_BOLD="\033[1m"
SUDO_COMMAND="sudo"

status () {
  echo "---> ${@}" >&2
}

abort () {
  echo "$@" >&2
  exit 1
}

ok () {
  echo "${ANSI_GREEN}${ANSI_BOLD}OK:${ANSI_RESET} ${ANSI_GREEN}${@}${ANSI_RESET}" >&2
}

warn () {
  echo "${ANSI_YELLOW}${ANSI_BOLD}WARNING:${ANSI_RESET} ${ANSI_YELLOW}${@}${ANSI_RESET}" >&2
}

error () {
  echo "${ANSI_RED}${ANSI_BOLD}ERROR:${ANSI_RESET} ${ANSI_RED}${@}${ANSI_RESET}" >&2
}

sudo_prompt () {
  $SUDO_COMMAND -p "This step requires administrator privileges. Password: " "$@"
}

countdown () {
  printf "$@ in " >&2
  for i in 5 4 3 2 1; do
    printf "$i"
    sleep 1
    printf "\b"
  done
  printf "\b\b\b"
  echo "now..."
}

install_homebrew () {
  countdown "Installing homebrew for you"
  ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
}

install_git () {
  countdown "Installing git for you"
  brew install git
}

have_gem () {
  gem list -i "$1" -v "= $2" >/dev/null
}

install_gem () {
  # check if rubygems is owned by root
  if [ "$(stat -f"%u" "$(gem which rubygems)")" -eq "0" ]; then
    sudo_prompt gem install -v "= ${2}" "$1"
  else
    gem install -v "= ${2}" "$1"
  fi
}

fetch_repo () {
  if [ -e "$1" ]; then
    if [ ! -d "$1/.git" ]; then
      warn "$1 exists but isn't a git repository. Wut?"
    else
      ok "$1 already cloned"
    fi
  else
    attempts=0
    until git clone "${2}/${1}.git" || [ $attempts -gt 3 ]; do
      warn "failed to clone $1. Trying again in a moment."
      sleep 2
      attempts=`expr $attempts + 1`
      if [ $attempts -eq 3 ]; then
        # We've tried 3 times - skip this repo. Perhaps it's been renamed?
        attempts=4
      fi
    done
    if [ $attempts -eq 4 ]; then
      warn "Failed to clone $1. Skipping"
    fi
  fi
}

random_ip_byte () {
  ruby -e 'puts rand(254) + 1'
}

if [ "$(id -u)" -eq "0" ]; then
  abort "This script is not intended to be run as root. Rerun without su/sudo."
fi

if [ "$(basename "$(pwd)")" = "development" ] && [ -e ".git" ]; then
  abort "This script is not intended to be run directly from the development repo. Quitting."
fi

if [ "$(uname -s)" != "Darwin" ]; then
  abort "This script will only work on a Mac at the moment, sorry!"
fi

status "Let's get you ready to build GOV.UK"

echo
echo "You should take a look at: https://github.com/alphagov/gds-boxen"
echo
echo "This script will download the GOV.UK git repositories to the"
echo "directory '$(pwd)'"
echo

countdown "Proceeding"

status "Installing git (and, if necessary, homebrew)"

if which git >/dev/null 2>&1; then
  ok "Found git"
else
  if which brew >/dev/null 2>&1; then
    ok "Found homebrew"
  else
    install_homebrew

    warn "Make sure to follow the instructions at the end of the homebrew install"
    warn "process above these lines. Then rerun this program."
    exit
  fi

  install_git
fi

status "Installing vagrant and vagrant-dns from rubygems"

ensure_gem () {
  local gem=$1
  local version=$2
  if have_gem "$gem" "$version"; then
    ok "Found ${gem}"
  else
    install_gem "$gem" "$version"
  fi
}

ensure_gem vagrant "$GEM_VERSION_VAGRANT"
ensure_gem rubydns "$GEM_VERSION_RUBYDNS"
ensure_gem vagrant-dns "$GEM_VERSION_VAGRANTDNS"
# vagrant-dns has a tacit dependency on daemons: https://github.com/BerlinVagrant/vagrant-dns/issues/7
ensure_gem daemons "$GEM_VERSION_DAEMONS"

status "Fetching development repository"
fetch_repo development $GOVUK_GITHUB_ENT

status "Reading list of public repositories from development/REPOS and fetching from GitHub"
while read repo; do
  fetch_repo "$repo" "$GOVUK_GITHUB_PUBLIC"
done < "development/REPOS"

status "Reading list of private repositories from development/GHE_REPOS and fetching from GitHub Enterprise"
while read repo; do
  fetch_repo "$repo" "$GOVUK_GITHUB_ENT"
done < "development/GHE_REPOS"

status "Updating Vagrantfile.local for your development VM"

if [ -e development/Vagrantfile.local ]; then
  ok "development/Vagrantfile.local exists already"
  if ( ! grep 'modifyvm.*--memory' development/Vagrantfile.local >/dev/null 2>&1 ); then
    warn "You can make your VM faster by increasing its memory. Add this line to your development/Vagrantfile.local: "
    warn "config.vm.customize ['modifyvm', :id, '--memory', 2048]"
  fi
else
  IP_A=$(random_ip_byte)
  IP_B=$(random_ip_byte)
  IP_C=$(random_ip_byte)

  IP="10.${IP_A}.${IP_B}.${IP_C}"

  echo "config.vm.network :hostonly, '${IP}'" >> development/Vagrantfile.local
  echo "config.vm.customize ['modifyvm', :id, '--memory', 2048]" >> development/Vagrantfile.local
  ok "development/Vagrantfile.local updated. VM IP: ${IP}"
fi

cd development

status "Checking whether you use rvm or rbenv to manage ruby"

if which rbenv >/dev/null 2>&1; then
  if ! rbenv commands | grep -q sudo; then
    countdown "Found rbenv but not rbenv-sudo. Going to install rbenv-sudo in your rbenv plugins folder"
    mkdir -p "$(rbenv root)/plugins"

    # This was originally dcarley/rbenv-sudo, but I've switched this to use my
    # fork in order to address a minor bug preventing the use of flags to sudo
    # (such as -p, used above). See
    # https://github.com/dcarley/rbenv-sudo/pull/2 for further details.
    git clone git://github.com/nickstenning/rbenv-sudo.git "$(rbenv root)/plugins/rbenv-sudo"
  fi
  SUDO_COMMAND="rbenv sudo"
  ok "Found rbenv and rbenv-sudo: using 'rbenv sudo' to elevate privileges"
fi

if which rvm >/dev/null 2>&1; then
  SUDO_COMMAND="rvmsudo"
  ok "Found rvm: using 'rvmsudo' to elevate privileges"
  warn "rvm is clinically insane (for proof, do \`which cd\`). Consider trying rbenv: https://github.com/sstephenson/rbenv"
fi

status "Checking vagrant-dns resolver file"

if [ -e "/etc/resolver/${GOVUK_DEV_DOMAIN}" ]; then
  ok "Found vagrant-dns resolver file"
else
  status "Going to install vagrant-dns resolver file to /etc/resolver/${GOVUK_DEV_DOMAIN}"
  sudo_prompt vagrant dns --install
fi

status "Ensuring current user owns ~/.vagrant.d"
sudo_prompt chown -R "$USER" "${HOME}/.vagrant.d"

status "Touching /etc/exports to trigger NFSd start"
sudo_prompt touch /etc/exports

status "Starting vagrant VM (this might take a minute or two)"
vagrant up

status "All done!"

cat <<EOM
Excellent. The install process appears to have completed successfully.
To log into your VM you must change directory to the 'development' repository
and run \`vagrant ssh\`. For further options to vagrant, run \`vagrant help\`.

  cd development && vagrant ssh

Once logged into the VM, you can provision the machine using puppet:

  govuk_puppet

GOV.UK repositories (those we just checked out) live in /var/govuk. Instructions
for running applications can be found in /var/govuk/development/README.md.

  less /var/govuk/development/README.md
EOM
