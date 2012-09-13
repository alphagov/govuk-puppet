class ssh {

  anchor { 'ssh::begin':
    notify => Class['ssh::service'];
  }

  class { 'ssh::package':
    require => Anchor['ssh::begin'],
    notify  => Class['ssh::service'];
  }

  class { 'ssh::config':
    require => Class['ssh::package'],
    notify  => Class['ssh::service'];
  }

  class { 'ssh::service':
    notify => Anchor['ssh::end'],
  }

  anchor { 'ssh::end': }

  # Export this machine's SSH RSA key to the puppetmaster
  @@sshkey { $::fqdn:
    type    => 'ssh-rsa',
    key     => $::sshrsakey,
    require => Class['ssh::service'],
  }

  # Collect the keys of all machines that share your puppetmaster
  Sshkey <<||>>

}
