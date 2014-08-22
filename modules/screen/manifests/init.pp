# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class screen {

  package { 'screen':
    ensure => present,
  }

  file { '/etc/screenrc':
    ensure => present,
    source => 'puppet:///modules/screen/screenrc',
  }

}
