class users {
  group { 'admin':
    name        => 'admin',
    gid         => '3000';
  }
  group { 'deploy':
    ensure  => 'present',
    name    => 'deploy',
  }
  user { 'deploy':
    ensure      => present,
    home        => '/home/deploy',
    managehome  => true,
    shell       => '/bin/bash',
    gid         => 'deploy',
    require     => Group['deploy'];
  }
  file { '/data':
    ensure  => directory,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => '0755',
    require => User['deploy'],
  }
  ssh_authorized_key { 'deploy_key_jenkins':
    ensure  => present,
    key     => extlookup('jenkins_key', ''),
    type    => 'ssh-rsa',
    user    => 'deploy',
  }
  if $::govuk_platform == 'preview' and $::govuk_class == 'support' {
    $mysql_host = 'rds.cluster'
    $mysql_user = 'backup'
    /*  WARNING: this fallback is in place to keep the rspec build happy.
        However, it will fail silently if the external data is not present,
        for example if deployed with the wrong version of the CSV file.
    */
    $mysql_password = extlookup('mysql_preview_backup', '')

    file { '/home/deploy/.my.cnf':
      ensure  => file,
      owner   => 'deploy',
      group   => 'deploy',
      mode    => '0600',
      require => User['deploy'],
      content => template('users/my.cnf')
    }
  }
}
