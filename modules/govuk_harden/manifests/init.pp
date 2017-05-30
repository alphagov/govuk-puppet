# == Class: govuk_harden
#
# Applies some basic OS hardening.
#
class govuk_harden {

  include ::govuk_pam
  include ::govuk_harden::sysctl

  # On modern Ubuntu, these are symlinks to SSH, so Bastille's protectrhost
  # doesn't work. Just remove the symlinks.
  file { [ '/usr/bin/rlogin', '/usr/bin/rsh', '/usr/bin/rcp', ]:
    ensure => absent,
  }

  # Remove setuid privileges
  file { [
      '/bin/mount',
      '/bin/umount',
      '/bin/fusermount',
      '/usr/bin/arping',
      '/usr/bin/mtr',
      '/usr/bin/traceroute6',
      '/usr/bin/traceroute6.iputils',
    ]:
    mode => '0755',
  }

  # Locking down console logins
  # Deny root login on console(s)
  file { '/etc/securetty':
    ensure  => present,
    content => "null\n",
  }

  # login(1), init(8) and getty(8) will not perform record-keeping, or
  # attempt to recreate this file, if it doesn't exist.
  file { '/var/log/wtmp':
    ensure => present,
    owner  => 'root',
    group  => 'utmp',
    mode   => '0664',
  }

  file { '/etc/security/access.conf':
    ensure => present,
    source => 'puppet:///modules/govuk_harden/access.conf',
    owner  => 'root',
    group  => 'root',
  }

  file { '/etc/ssh/ssh_config':
    ensure => present,
    source => 'puppet:///modules/govuk_harden/ssh_config',
    owner  => 'root',
    group  => 'root',
  }

}
