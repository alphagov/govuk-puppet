class puppet::cronjob {

  $first = fqdn_rand_fixed(30)
  $second = $first + 30

  cron { 'puppet':
    ensure  => present,
    user    => 'root',
    minute  => [$first, $second],
    command => '/usr/bin/puppet agent --onetime --no-daemonize',
  }
}
