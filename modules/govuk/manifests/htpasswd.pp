class govuk::htpasswd {

  $http_username = extlookup('http_username','notset')
  $http_passhash = extlookup('http_password','notset')
  file { '/etc/govuk.htpasswd':
    ensure  => 'present',
    content => "${http_username}:${http_passhash}\n",
  }

}
