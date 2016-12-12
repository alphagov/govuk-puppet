# == Class: base
#
# Pull in a standard set of modules for all machines. Used everywhere, by
# both `govuk::node::s_base` and `govuk::node::s_development`.
#
class base {
  include apparmor
  include apt
  include base::packages
  include base::supported_kernel
  include cron
  include curl
  include gcc
  include govuk::deploy
  include govuk_apt::unused_kernels
  include govuk_apt::package_blacklist
  include govuk_envsys
  include govuk_scripts
  include govuk_sshkeys
  include govuk_sudo
  include govuk_unattended_reboot
  include logrotate
  include motd
  include ntp
  include puppet
  include resolvconf
  include screen
  include shell
  include ssh
  include timezone
  include tmpreaper
  include unattended_upgrades
  include users
  include wget
}
