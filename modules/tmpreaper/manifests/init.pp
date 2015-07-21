# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class tmpreaper {

  package { 'tmpreaper':
    ensure => present,
  }

  file { '/etc/tmpreaper.conf':
    ensure => present,
    source => 'puppet:///modules/tmpreaper/tmpreaper.conf',
  }

}
