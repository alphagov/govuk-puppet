class akamai_logs {
  $user = 'logkeeper'
  $local_logs_dir = "/home/${user}/akamai"
  $akamai_user = "sshacs"
  $akamai_host = "govdigital.upload.akamai.com"
  $path_to_logs = "184928/logs"
  $backup_host = "akamai-logs-backup-1"

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

  file { ["/mnt/akamai", "/mnt/akamai/logs", "/var/log/akamai"]:
    ensure  => directory,
    owner   => $user
  }

  file { $local_logs_dir:
    ensure  => symlink,
    owner   => $user,
    target  => "/mnt/akamai"
  }

  file { "/home/${user}/pull_logs.sh":
    ensure  => present,
    content => template("akamai_logs/pull_logs.sh.erb"),
    owner   => $user,
    group   => $user,
    mode    => '0744'
  }

  file { "/etc/akamai_logs":
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy'
  }

  cron { "fetch-logs-from-akamai":
    command => "/home/${user}/pull_logs.sh >> /var/log/akamai/out.log 2>> /var/log/akamai/error.log",
    user    => $user,
    require => User[$user],
    hour    => '*/4',
    minute  => '1'
  }

  @logrotate::conf { "akamai-logs":
    matches => "/var/log/akamai/*.log"
  }

  @nagios::plugin { "check_akamai_logs"
    content => template("akamai_logs/check_akamai_logs.sh.erb")
  }

  @nagios::nrpe_config { "check_akamai_logs"
    content => "command[check_akamai_logs]=/usr/lib/nagios/plugins/check_akamai_logs"
  }

  @@nagios::check { "check_akamai_logs_${::hostname}"
    check_command       => 'check_nrpe_1arg!check_akamai_logs',
    service_description => "no recently fetched akamai logs",
    host_name           => $::fqdn
  }

  include akamai_logs::log_scanner
}
