class puppet::cronjob {

  $first = fqdn_rand_fixed(30)
  $second = $first + 30

  case $::govuk_provider {
    sky: {
      cron { 'puppet': ensure => absent }
    }
    default: {
      cron { 'puppet':
        ensure  => present,
        user    => 'root',
        minute  => [$first, $second],
        command => '/usr/bin/puppet agent --onetime --no-daemonize',
        require => Package['puppet'];
      }
    }
  }
}
