class govuk_node::akamai_logs_backup inherits govuk_node::base {
  $user = 'logkeeper'

  user { $user:
    ensure      => present,
    home        => "/home/${user}",
    managehome  => true
  }

  package { 'rsync':
    ensure => present
  }

  file { "/home/${user}/.ssh":
    ensure  => directory,
    owner   => $user
  }

  ssh_authorized_key { 'akamai_log_box':
    ensure  => present,
    type    => 'ssh-rsa',
    key     => extlookup('akamai_logs_key', ''),
    user    => $user,
    require => User[$user]
  }

  file { '/mnt/logs':
    ensure  => directory,
    owner   => $user
  }
}