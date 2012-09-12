class ganglia::package {

  include nginx
  include nginx::php

  package {
    'gmetad':
      ensure  => 'installed',
      before  => Package['ganglia-monitor']; # Stupid bug in lucid makes this order-dependent.
    'rrdtool':
      ensure  => 'installed';
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
    require     => [Package['gmetad'], Package['rrdtool']]
  }

  exec { 'ganglia_webfrontend_untar':
    command => 'tar zxf /tmp/ganglia-web-3.5.0.tar.gz && chown -R www-data:www-data /var/www/ganglia-web-3.5.0',
    cwd     => '/var/www/',
    unless  => '/usr/bin/test -s /var/www/ganglia-web-3.5.0',
    require => Wget::Fetch[ganglia-webfrontend]
  }
}
