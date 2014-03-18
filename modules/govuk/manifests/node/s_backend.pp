class govuk::node::s_backend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server
  include java::oracle7::jdk
  include java::oracle7::jre

  harden::limit { 'root-nofile':
    domain => 'root',
    type   => '-', # set both hard and soft limits
    item   => 'nofile',
    value  => '16384',
  }

  harden::limit { 'root-nproc':
    domain => 'root',
    type   => '-', # set both hard and soft limits
    item   => 'nproc',
    value  => '1024',
  }

  class { 'java::set_defaults':
    jdk => 'oracle7',
    jre => 'oracle7',
  }

  package { 'graphviz':
    ensure => installed
  }

  include imagemagick

  $app_domain = hiera('app_domain')

  include govuk::apps::asset_manager
  include govuk::apps::business_support_api
  include govuk::apps::canary_backend
  if str2bool(extlookup('govuk_enable_contacts', 'no')) {
    class { 'govuk::apps::contacts':
      vhost_protected => true,
      vhost           => 'contacts-admin',
    }
  }
  include govuk::apps::content_planner
  class { 'govuk::apps::external_link_tracker':
    mongodb_nodes => [
      'mongo-1.backend',
      'mongo-2.backend',
      'mongo-3.backend',
    ]
  }
  include govuk::apps::fact_cave
  include govuk::apps::finder_api
  include govuk::apps::govuk_delivery
  include govuk::apps::imminence
  include govuk::apps::kibana
  include govuk::apps::maslow
  include govuk::apps::need_api
  include govuk::apps::need_o_tron
  include govuk::apps::panopticon
  include govuk::apps::publisher
  include govuk::apps::release
  include govuk::apps::search
  include govuk::apps::signon
  include govuk::apps::specialist_publisher
  include govuk::apps::support
  include govuk::apps::tariff_admin
  include govuk::apps::tariff_api
  include govuk::apps::transition
  include govuk::apps::travel_advice_publisher

  class { 'govuk::apps::contentapi': vhost_protected => false }
  class { 'govuk::apps::frontend':   vhost_protected => true  }

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  # Local proxy for Rummager to access ES cluster.
  class { 'elasticsearch::local_proxy':
    servers => [
      'elasticsearch-1.backend',
      'elasticsearch-2.backend',
      'elasticsearch-3.backend',
    ],
  }

  # Ensure memcached is available to backend nodes
  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
