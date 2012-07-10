class graphite {
  class { 'nginx' : node_type => graphite }
  file { [ '/var/log/graphite' ]:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}