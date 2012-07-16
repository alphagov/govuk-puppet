class elasticsearch::monitoring {
  file { '/etc/ganglia/conf.d/elasticsearch.pyconf':
    source  => 'puppet:///modules/elasticsearch/elasticsearch.pyconf',
    require => [Service['elasticsearch'],Service['ganglia-monitor']]
  }

  file { '/usr/lib/ganglia/python_modules/elasticsearch.py':
    source  => 'puppet:///modules/elasticsearch/elasticsearch.py',
    mode    => '0755',
    require => [Service['elasticsearch'],Service['ganglia-monitor']]
  }
}
