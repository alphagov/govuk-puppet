class solr {
  include java

  user { 'solr':
    ensure => present,
  }

  file { '/etc/solr':
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/solr/etc/solr',
    notify  => Service['solr'],
  }

  file { '/opt/solr/solr/solr.xml':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['gds-solr'],
    source  => 'puppet:///modules/solr/solr.xml',
  }

  file { '/var/log/solr':
    ensure  => directory,
    owner   => 'solr',
    group   => 'solr',
    require => User['solr'],
  }

  graylogtail::collect { 'graylogtail-solr':
    log_file => '/var/log/solr/solr.log',
    facility => 'solr',
  }

  file { '/var/solr':
    ensure  => directory,
    recurse => true,
    owner   => 'solr',
    group   => 'solr',
    require => User['solr'],
    source  => 'puppet:///modules/solr/var/solr',
  }

  package { 'gds-solr':
    name    => 'gds-solr',
    require => Package['java']; # FIXME: the *deb* should depend on java.
  }

  service { 'solr':
    ensure   => running,
    provider => upstart,
    require  => [
      File['/opt/solr/solr/solr.xml'],
      File['/etc/solr'],
      Package['gds-solr'],
    ],
  }
}
