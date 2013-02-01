class solr {
  include java::sun6::jre

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
    require => Class['java::sun6::jre']; # FIXME: the *deb* should depend on java.
  }

  @ufw::allow { "allow-solr-from-all":
    port => 8983,
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
