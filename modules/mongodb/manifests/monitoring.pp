class mongodb::monitoring {
  include ganglia::client

  file { '/etc/ganglia/conf.d/mongodb.pyconf':
    source  => 'puppet:///modules/mongodb/ganglia_mongodb.conf',
    require => [Service['mongodb'],Service['ganglia-monitor']]
  }

  file { '/usr/lib/ganglia/python_modules/mongodb.py':
    source  => 'puppet:///modules/mongodb/ganglia_mongodb.py',
    require => [Service['mongodb'],Service['ganglia-monitor']]
  }

}
