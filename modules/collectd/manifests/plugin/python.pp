class collectd::plugin::python {
  @file { '/usr/lib/collectd/python':
    ensure  => directory,
    purge   => true,
    recurse => true,
    tag     => 'collectd::plugin',
    require => Class['collectd::config'],
  }

  @file { '/usr/lib/collectd/python/__init__.py':
    ensure  => present,
    content => '',
    tag     => 'collectd::plugin',
  }

  # File naming ensures that Python support is loaded before any plugins
  # that require Python support.
  @collectd::plugin { '00-python':
    source  => 'puppet:///modules/collectd/etc/collectd/conf.d/00-python.conf',
    require => File['/usr/lib/collectd/python/__init__.py'],
  }
}
