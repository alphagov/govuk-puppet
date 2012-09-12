class nginx::php {

  include ::php

  file { '/etc/nginx/conf.d/php.conf':
    ensure  => present,
    content => 'upstream php { server unix:/var/run/php5-fpm.sock; }',
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
  }

}
