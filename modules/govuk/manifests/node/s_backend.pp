# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_backend inherits govuk::node::s_base {
  include govuk::node::s_ruby_app_server

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

  package { 'graphviz':
    ensure => installed
  }

  include imagemagick

  $app_domain = hiera('app_domain')

  include govuk::apps::asset_manager
  include govuk::apps::business_support_api
  include govuk::apps::canary_backend
  include govuk::apps::collections_api
  include govuk::apps::collections_publisher

  class { 'govuk::apps::contacts':
    vhost_protected => true,
    vhost           => 'contacts-admin',
  }

  include govuk::apps::content_planner
  include govuk::apps::email_alert_api
  include govuk::apps::email_alert_service
  class { 'govuk::apps::external_link_tracker':
    mongodb_nodes => [
      'mongo-1.backend',
      'mongo-2.backend',
      'mongo-3.backend',
    ]
  }
  include govuk::apps::fact_cave # FIXME: remove once cleaned up.
  include govuk::apps::finder_api
  include govuk::apps::govuk_delivery
  include govuk::apps::hmrc_manuals_api
  include govuk::apps::imminence
  include govuk::apps::kibana
  include govuk::apps::maslow
  include govuk::apps::need_api
  include govuk::apps::panopticon
  include govuk::apps::publisher
  include govuk::apps::release
  include govuk::apps::search
  include govuk::apps::search_admin
  include govuk::apps::short_url_manager
  include govuk::apps::sidekiq_monitoring
  include govuk::apps::signon
  include govuk::apps::specialist_publisher
  include govuk::apps::support
  include govuk::apps::support_api
  include govuk::apps::tariff_admin
  include govuk::apps::tariff_api
  include govuk::apps::transition
  include govuk::apps::transition_postgres
  include govuk::apps::travel_advice_publisher
  include govuk::apps::url_arbiter

  class { 'govuk::apps::contentapi': vhost_protected => false }
  class { 'govuk::apps::frontend':   vhost_protected => true  }

  include nginx

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default': }

  # Local proxy for Rummager to access ES cluster.
  include govuk_elasticsearch::local_proxy

  # Ensure memcached is available to backend nodes
  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
