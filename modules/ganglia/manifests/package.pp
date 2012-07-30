class ganglia::package {
  include apache2
  package {
    'gmetad':
      ensure  => 'installed',
      require => Package['ganglia-webfrontend'];
    'rrdtool':
      ensure  => 'installed',
      require => Package['ganglia-webfrontend'];
    'php5':
      ensure  => 'installed',
      require => Package['ganglia-webfrontend'],
      notify  => Service[apache2]
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
    require => [Wget::Fetch[ganglia-webfrontend], Service[apache2], Package[php5]]
  }
}
