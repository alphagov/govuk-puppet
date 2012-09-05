class govuk_node::cache_server inherits govuk_node::base {
  class { 'varnish': storage_size => '6G', default_ttl => 900 }

  include router
  include jetty
  include mirror

  class { 'nginx': node_type => router}

}
