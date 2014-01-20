# == CLass: akamai_logs
#
# DEPRECATED. No longer run from cron. Can be removed when we no longer have
# the box on Skyscape interim.
#
# On Logs Box
# /home/logkeeper/akamai    - link to /mnt/akamai
# /mnt                      - mounted
# /mnt/akamai               - root of logs
#
# On Akamai
# 184928                    - Root of all logs
#
# Rsync
# 184928/ -> /home/logkeeper/akamai
class akamai_logs {
  $user = 'logkeeper'
  $local_logs_dir = "/home/${user}/akamai"
  $akamai_user = 'sshacs'
  $akamai_host = 'govdigital.upload.akamai.com'
  $path_to_logs = '184928'
  $backup_host = 'akamai-logs-backup-1'

  user { $user:
    ensure      => present,
    home        => "/home/${user}",
    managehome  => true,
  }

  package { 'rsync':
    ensure => present
  }

  file { "/home/${user}/.ssh":
    ensure  => directory,
    owner   => $user
  }

  file { ['/mnt/akamai', '/var/log/akamai', '/mnt/akamai-workspace']:
    ensure  => directory,
    owner   => $user,
    require => Govuk::Mount['akamai-mount'],
  }

  govuk::mount { 'akamai-mount':
    mountpoint   => '/mnt',
    disk         => '/dev/sdb1',
    mountoptions => 'errors=remount-ro',
    nagios_warn  => 10,
    nagios_crit  => 5,
  }

  file { $local_logs_dir:
    ensure  => symlink,
    owner   => $user,
    target  => '/mnt/akamai'
  }

  file { "/home/${user}/pull_logs.sh":
    ensure  => present,
    content => template('akamai_logs/pull_logs.sh.erb'),
    owner   => $user,
    group   => $user,
    mode    => '0744'
  }

  file { '/etc/akamai_logs':
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy'
  }

  @logrotate::conf { 'akamai-logs':
    matches => '/var/log/akamai/*.log'
  }

  @nagios::plugin { 'check_akamai_logs':
    content => template('akamai_logs/check_akamai_logs.sh.erb')
  }

  @nagios::nrpe_config { 'check_akamai_logs':
    content => 'command[check_akamai_logs]=/usr/lib/nagios/plugins/check_akamai_logs'
  }

  include akamai_logs::log_scanner
}
