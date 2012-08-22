class puppet::cronjob {

  $first = fqdn_rand_fixed(30)
  $second = $first + 30

  case $::govuk_provider {
    sky: {
      cron { 'puppet':
        ensure  => absent,
        user    => 'root',
        minute  => [$first, $second],
        command => '/usr/bin/puppet agent --onetime --no-daemonize; /bin/chmod 644 /var/lib/puppet/state/*.yaml',
        require => Package['puppet'];
      }
    }
    default: {
      cron { 'puppet':
        ensure  => present,
        user    => 'root',
        minute  => [$first, $second],
        command => '/usr/bin/puppet agent --onetime --no-daemonize; /bin/chmod 644 /var/lib/puppet/state/*.yaml',
        require => Package['puppet'];
      }
    }
  }
}
