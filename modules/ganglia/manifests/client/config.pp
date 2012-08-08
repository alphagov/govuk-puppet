class ganglia::client::config {
  file { ['/usr/lib/ganglia/python_modules', '/etc/ganglia/conf.d', '/etc/ganglia/scripts']:
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { '/etc/ganglia/gmond.conf':
    source  => 'puppet:///modules/ganglia/gmond.conf',
  }
}
