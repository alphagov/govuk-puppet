class govuk::node::s_akamai_logs_backup inherits govuk::node::s_base {
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

  file { ["/mnt/akamai", "/mnt/akamai/logs"]:
    ensure  => directory,
    owner   => $user
  }

  file { "/home/$user/akamai":
    ensure  => symlink,
    owner   => $user,
    target  => "/mnt/akamai"
  }
}
