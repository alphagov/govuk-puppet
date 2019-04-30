# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppet::puppetserver::service {
  service { 'puppetserver':
    ensure => running,
    notify => File['/etc/monit/conf.d/puppetserver', '/etc/monit/conf.d/puppetdb'],
  }

  file { '/etc/monit/conf.d/puppetserver':
    ensure => present,
    source => 'puppet:///modules/puppet/etc/monit/conf.d/puppetserver',
    mode   => '0660',
    notify => Service['monit'],
  }

  file { '/etc/monit/conf.d/puppetdb':
    ensure => present,
    source => 'puppet:///modules/puppet/etc/monit/conf.d/puppetdb',
    mode   => '0660',
    notify => Service['monit'],
  }

  service { 'monit':
    ensure   => running,
  }

  collectd::plugin::process { 'service-puppetserver':
    regex  => '\/usr\/share\/puppetserver\/puppet-server-release\.jar',
  }
}
