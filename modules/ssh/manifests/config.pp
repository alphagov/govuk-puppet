class ssh::config {
  $ssh_allow_users = extlookup('ssh_allow_users', '*')
  file { '/etc/ssh/sshd_config':
    content => template('ssh/sshd_config.erb'),
    mode    => '0400',
  }

  # This is being created with 0600 permisisons in some cases, which renders is
  # much less useful.  Force it to be world readable.
  file { '/etc/ssh/ssh_known_hosts':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

}
