class loadbalancer::cron {
  file{ '/usr/local/bin/stop_loadbalancer':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/loadbalancer/stop_loadbalancer.sh'
  }

  cron { 'update-latest-to-mirror':
    ensure  => present,
    user    => 'root',
    minute  => '*/1',
    command => '/usr/local/bin/stop_loadbalancer',
    require => File['/usr/local/bin/stop_loadbalancer'],
  }
}