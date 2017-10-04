# == Class: govuk_harden::pam
#
# Installs and manages some local PAM settings
#
class govuk_harden::pam {

  $pam_packages = [
    'libpam-passwdqc',
    'libpam-tmpdir',
  ]

  package { $pam_packages:
    ensure => installed,
  }

  # Set a restrictive umask
  file { '/etc/pam.d/common-session':
    ensure    => present,
    content   => file('govuk_harden/pam/common-session'),
    subscribe => Package['libpam-tmpdir'],
    owner     => 'root',
    group     => 'root',
  }

  file { '/etc/pam.d/common-session-noninteractive':
    ensure    => present,
    content   => file('govuk_harden/pam/common-session-noninteractive'),
    subscribe => Package['libpam-tmpdir'],
    owner     => 'root',
    group     => 'root',
  }

}
