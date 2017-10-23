# == Class: govuk_htpasswd
#
# Create an htpasswd file which can be used for HTTP basic authentication
#
# === Parameters
#
# [*http_users*]
#   Array of users with a password hash.
#
class govuk_htpasswd (
  $http_users = {},
){

  validate_hash($http_users)

  file { '/etc/govuk.htpasswd':
    ensure  => 'present',
    content => template('govuk_htpasswd/govuk.htpasswd.erb'),
  }

}
