# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_elasticsearch::dump (
  $run_es_dump_hour = '3',
) {

  package { 'rake':
    ensure   => '12.2.0',
    provider => 'system_gem',
  }

  package { 'es_dump_restore':
    ensure   => '2.2.2',
    provider => 'system_gem',
    require  => Package['rake'],
  }

  file { '/var/es_dump':
    ensure => directory,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
  }

  file { '/usr/bin/es_dump':
    ensure => file,
    source => 'puppet:///modules/govuk_elasticsearch/es_dump',
    mode   => '0755',
  }

  cron { 'dump-elasticsearch-indexes':
    command => '/usr/bin/es_dump http://localhost:9200 /var/es_dump',
    user    => 'elasticsearch',
    require => [
      File['/var/es_dump'],
      File['/usr/bin/es_dump'],
    ],
    hour    => $run_es_dump_hour,
    minute  => '0',
  }
}
