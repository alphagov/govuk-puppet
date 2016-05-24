# == Class: puppet::cronjob
#
# Sets up a cronjob that runs Puppet periodically.
#
class puppet::cronjob {

  $first = fqdn_rand(30)
  $second = $first + 30

  cron { 'puppet':
    ensure  => present,
    user    => 'root',
    minute  => [$first, $second],
    command => '/usr/local/bin/govuk_puppet',
    require => File['/usr/local/bin/govuk_puppet'],
  }
}
