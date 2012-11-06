class ssh::config {
  $ssh_allow_users = extlookup('ssh_allow_users', '*')
  file { '/etc/ssh/sshd_config':
    content => template('ssh/sshd_config.erb'),
    mode    => '0400',
  }

}
