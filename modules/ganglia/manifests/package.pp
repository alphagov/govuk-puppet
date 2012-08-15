class ganglia::package {
  include apache2
  package {
    'gmetad':
      before  => Package['ganglia-monitor'], # Stupid bug in lucid makes this order-dependent.
      ensure  => 'installed';
    'rrdtool':
      ensure  => 'installed';
    'php5':
      ensure  => 'installed',
      notify  => Class['apache2::service']
  }

  exec { 'disable-default-gmetad':
    command     => '/etc/init.d/gmetad stop && /bin/rm /etc/init.d/gmetad && /usr/sbin/update-rc.d gmetad remove',
    subscribe   => Package['gmetad'],
    refreshonly => true,
  }

  file { '/etc/init/gmetad.conf':
    source  => 'puppet:///modules/ganglia/etc/init/gmetad.conf',
    require => Package['gmetad'],
  }

  wget::fetch { 'ganglia-webfrontend':
    source      => 'http://sourceforge.net/projects/ganglia/files/ganglia-web/3.5.0/ganglia-web-3.5.0.tar.gz/download',
    destination => '/tmp/ganglia-web-3.5.0.tar.gz',
    require     => [Package['gmetad'],Package['rrdtool'],Package['php5']]
  }
  exec { 'ganglia_webfrontend_untar':
    command => 'tar zxf /tmp/ganglia-web-3.5.0.tar.gz && chown -R www-data:www-data /var/www/ganglia-web-3.5.0',
    path    => '/bin',
    cwd     => '/var/www/',
    unless  => '/usr/bin/test -s /var/www/ganglia-web-3.5.0',
    require => [Wget::Fetch[ganglia-webfrontend]]
  }
}
