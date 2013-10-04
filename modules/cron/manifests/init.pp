# Class: cron
#
# Purge unmanaged cron entries! This only checks root's crontab. Any cron
# entries created by hand without a preceding `Puppet Name:` comment will
# cause Puppet to raise the error:
#
#     Failed to generate additional resources using 'generate': Title or
#     name must be provided
#
class cron {
  resources { 'cron':
    purge => true,
  }

  service { 'cron':
    ensure => running,
  }

  # set the timings of the scheduled tasks at different times
  # for each machine, but at predicable times for the various
  # schedules.
  # Hourly:  01 -> 15 minutes past the hour
  $hourly_time  = fqdn_rand(15) + 1
  # Daily:   11 -> 25 minutes past the hour
  $daily_time   = $hourly_time + 10
  # Weekly:  26 -> 40 minutes past the hour
  $weekly_time  = $hourly_time + 25
  # Monthly: 41 -> 55 minutes past the hour
  $monthly_time = $hourly_time + 40
  file {'/etc/crontab':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cron/etc/crontab.erb'),
    notify  => Service['cron'],
  }
}
