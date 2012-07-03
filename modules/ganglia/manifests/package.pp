class ganglia::package {
  include wget, apache2
  package {
    'gmetad':
      ensure => 'installed';
    'php5':
      ensure => 'installed',
      notify => Service[apache2]
  }

  wget::fetch { 'ganglia-webfrontend':
    source      => 'http://sourceforge.net/projects/ganglia/files/ganglia-web/3.5.0/ganglia-web-3.5.0.tar.gz/download',
    destination => '/tmp/ganglia-web-3.5.0.tar.gz'
  }
  exec { 'ganglia_webfrontend_untar':
    command => 'tar zxf /tmp/ganglia-web-3.5.0.tar.gz && chown -R www-data:www-data /var/www/ganglia-web-3.5.0',
    path    => '/bin',
    cwd     => '/var/www/',
    unless  => '/usr/bin/test -s /var/www/ganglia-web-3.5.0',
    require => [Wget::Fetch[ganglia-webfrontend], Service[apache2], Package[php5]]
  }
}