class ssh::config {

  file { '/etc/ssh/sshd_config':
    content => template('ssh/sshd_config.erb'),
    mode    => '0400',
  }

}
