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

  class { 'ssh::firewall':
    require => Class['ssh::config'],
  }

  class { 'ssh::service':
    notify => Anchor['ssh::end'],
  }

  anchor { 'ssh::end':
    require => Class['ssh::firewall'],
  }

  # The "internally-qualified domain name" of a machine is the first two
  # components of its three-component name. i.e. the IQDN of a machine with
  # FQDN foo-1.bar.production is foo-1.bar. Internal references to other
  # machines which must be unambiguous (e.g. in deployment scripts) should use
  # the IQDN.
  $iqdn = regsubst($::fqdn, '\.[^\.]+$', '')

  # Export this machine's SSH RSA key to the puppetmaster
  @@sshkey { $::fqdn:
    type         => 'ssh-rsa',
    key          => $::sshrsakey,
    host_aliases => [$iqdn],
    require      => Class['ssh::service'],
  }

  # Collect the keys of all machines that share your puppetmaster
  Sshkey <<||>>

}
