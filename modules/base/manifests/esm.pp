# == Class: base::esm
#
# Installs extended security maintenance credentials and preferences
#
# === Parameters
#
# [*esm_token*]
#   Token for ESM repo.
#
class base::esm (
  $esm_token,
) {
  file { '/etc/apt/apt.conf.d/51ubuntu-advantage-esm':
    ensure => file,
    source => 'puppet:///modules/base/51ubuntu-advantage-esm',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
  file { '/etc/apt/auth.conf':
    ensure => absent,
  }
 exec { "ubuntu-advantage attach token":
    command => "ubuntu-advantage attach ${esm_token}",
    path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    require => Package['ubuntu-advantage-tools'],
  }
  package { 'ubuntu-advantage-tools':
    ensure  => latest,
  }
  package { 'apt-transport-https':
    ensure  => present,
  }
}
