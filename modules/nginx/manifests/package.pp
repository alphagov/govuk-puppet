# == Class: nginx::package
#
# Install nginx packages
#
# === Parameters
#
#  [*apt_mirror_hostname*]
#    The hostname of the local aptly mirror.
#
# [*nginx_version*]
#   Which version of the nginx package to install. Default: 'present'
#
# [*nginx_module_perl_version*]
#   Which version of the nginx perl module package to install. Default: 'present'
#
class nginx::package(
  $apt_mirror_hostname,
  $nginx_version             = 'present',
  $nginx_module_perl_version = 'present',
) {

  apt::source { 'nginx':
    location     => "http://${apt_mirror_hostname}/nginx",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    repos        => 'nginx',
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  if $::lsbdistcodename == 'precise' {
    apt::source { 'nginx-precise':
      location     => "http://${apt_mirror_hostname}/nginx-precise",
      release      => $::lsbdistcodename,
      architecture => $::architecture,
      repos        => 'nginx',
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
    }
  }

  package {
    'nginx':
      ensure => $nginx_version,
    ;
    'nginx-module-perl':
      ensure  => $nginx_module_perl_version,
      require => Package['nginx'],
  }
  ~> Service <| title == 'nginx' |>
}
