class govuk_node::cache_server inherits govuk_node::base {
  class { 'varnish': storage_size => '6G', default_ttl => 900 }

  include router
  include jetty
  include mirror

  class { 'nginx': node_type => router}

  # Have realised that this purge does not kick in the first puppet run[Newly provisioned machines]
  # Needs to be fixed. Unsure of how apache sneaks in.
  # Kicks in the the next puppet run
  package { 'apache2':
    ensure => absent,
  }

  service { 'apache2':
    ensure => stopped
  }
}
