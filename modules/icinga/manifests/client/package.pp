# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga::client::package {

  package { [
    'nagios-plugins-basic',
    'nagios-plugins-standard',
    'nagios-nrpe-server'
  ]:
    ensure => present
  }

}
