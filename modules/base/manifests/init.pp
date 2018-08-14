# == Class: base
#
# Pull in a standard set of modules for all machines. Used everywhere, by
# both `govuk::node::s_base` and `govuk::node::s_development`.
#
class base {
  class { '::apparmor':
    package_ensure => present,
  }

  include apt
  include base::packages
  include base::screen
  include base::shell
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

  unless $::lsbdistcodename == 'precise' {
    include govuk_awscli
  }

  include logrotate
  include ntp
  include puppet

  if ! $::aws_migration {
    include resolvconf
  }

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

    include hosts::migration
  }

  # TODO: remove this once it's run on all machines - or by 2018/09/01
  file { '/usr/lib/sysctl.d/elasticsearch.conf':
    ensure => 'absent',
  }
}
