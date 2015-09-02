# == Class: govuk::htpasswd
#
# Create an htpasswd file which can be used for HTTP basic authentication
#
# === Parameters
#
# [*http_passhash*]
#   Hash of a password created with `htpasswd`
#
class govuk::htpasswd (
  $http_passhash = 'notset',
){

  $http_username = hiera('http_username','notset')
  file { '/etc/govuk.htpasswd':
    ensure  => 'present',
    content => "${http_username}:${http_passhash}",
  }

}
