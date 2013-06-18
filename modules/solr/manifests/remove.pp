# = Class: solr::remove
#
# Remove all traces of solr now that we don't need it.
#
class solr::remove {
  service { 'solr':
    ensure   => stopped,
    pattern  => 'java .* -jar /opt/solr/start.jar',
    provider => 'base',
  }

  package { 'gds-solr':
    ensure  => purged,
    require => Service['solr'],
  }

  $directories = [
    '/etc/solr',
    '/opt/solr',
    '/var/log/solr',
    '/var/solr'
  ]

  file { $directories:
    ensure  => absent,
    purge   => true,
    recurse => true,
    force   => true,
    backup  => false,
    require => Package['gds-solr'],
  }

  user { 'solr':
    ensure  => absent,
    require => File[$directories],
  }
}
