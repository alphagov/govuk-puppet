class govuk::htpasswd (
  $http_passhash = 'notset',
){

  $http_username = hiera('http_username','notset')
  file { '/etc/govuk.htpasswd':
    ensure  => 'present',
    content => "${http_username}:${http_passhash}",
  }

}
