class licensify::apps::base {

  file { '/etc/licensing':
    ensure  => directory,
    mode    => '0755',
    owner   => 'deploy',
    group   => 'deploy',
  }
}
