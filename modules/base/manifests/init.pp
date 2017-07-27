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
  include govuk::deploy
  include govuk_apt::unused_kernels
  include govuk_apt::package_blacklist
  include govuk_envsys
  include govuk_scripts
  include govuk_sshkeys
  include govuk_sudo
  include govuk_unattended_reboot
  include logrotate
  include ntp
  include puppet

  if ! $::aws_migration {
    include resolvconf
  }

  include screen
  include shell
  include ssh
  include timezone
  include tmpreaper
  include unattended_upgrades
  include users
  include wget

  ensure_packages([ 'gcc', 'build-essential' ])

  if $::aws_migration {
    file { '/etc/motd':
      ensure  => 'present',
      content => template('base/motd.erb'),
    }

    # FIXME this is a temporary solution to fix ongoing connect errors before
    # we find the real resolution
    cron::crondotdee { 'dhclient_reload':
      command => '/usr/bin/host puppet >/dev/null || /sbin/dhclient -r; /sbin/dhclient',
      hour    => '*',
      minute  => '*/2',
      user    => 'root',
      mailto  => '""',
    }
  }
}
