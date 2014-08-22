# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::htpasswd (
  $http_passhash = 'notset',
){

  $http_username = hiera('http_username','notset')
  file { '/etc/govuk.htpasswd':
    ensure  => 'present',
    content => "${http_username}:${http_passhash}",
  }

}
