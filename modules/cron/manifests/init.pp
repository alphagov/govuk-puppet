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
  # schedules. See spec tests for what ranges these equate to.
  $hourly_min  = fqdn_rand(15) + 1
  $daily_min   = fqdn_rand(59)
  $weekly_min  = $hourly_min + 25
  $monthly_min = $hourly_min + 40
  file {'/etc/crontab':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cron/etc/crontab.erb'),
    notify  => Service['cron'],
  }

  # Drop a cron default file to cause /etc/cron.daily/standard to not run the
  # lost+found checks. Since we don't seem to care.
  file { '/etc/default/cron':
    source => 'puppet:///modules/cron/etc/default/cron',
  }
}
