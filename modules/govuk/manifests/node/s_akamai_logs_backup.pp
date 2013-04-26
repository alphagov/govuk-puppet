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

  $akamai_logs_ssh_key = extlookup('akamai_logs_key', 'NO_KEY_IN_EXTDATA')

  file { "/home/${user}/.ssh/authorized_keys":
    ensure  => present,
    owner   => $user,
    mode    => '0600',
    content => "ssh-rsa ${akamai_logs_ssh_key} akamai_log_box",
  }

  file { ["/mnt/akamai", "/mnt/akamai/logs"]:
    ensure  => directory,
    owner   => $user
  }

  file { "/home/${user}/akamai":
    ensure  => symlink,
    owner   => $user,
    target  => "/mnt/akamai"
  }
}
