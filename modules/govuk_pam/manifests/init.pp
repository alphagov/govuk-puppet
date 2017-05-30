# == Class: govuk_pam
#
# Installs and manages some local PAM settings
#
class govuk_pam {

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
    source    => 'puppet:///modules/govuk_pam/common-session',
    subscribe => Package['libpam-tmpdir'],
    owner     => 'root',
    group     => 'root',
  }

  file { '/etc/pam.d/common-session-noninteractive':
    ensure    => present,
    source    => 'puppet:///modules/govuk_pam/common-session-noninteractive',
    subscribe => Package['libpam-tmpdir'],
    owner     => 'root',
    group     => 'root',
  }


}
