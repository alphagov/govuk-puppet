# == Class: base
#
# Pull in a standard set of modules for all machines. Used everywhere, by
# both `govuk::node::s_base` and `govuk::node::s_development`.
#
class base {
  include apparmor
  include apt
  include apt::unattended_upgrades
  include base::packages
  include base::supported_kernel
  include cron
  include curl
  include gcc
  include govuk::deploy
  include govuk::envsys
  include govuk::scripts
  include govuk::sshkeys
  include govuk_apt::unused_kernels
  include govuk_rbenv
  include govuk_sudo
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
  include users
  include wget
}
