# == Class: govuk::node::publishing_api
#
# Publishing API machine definition. Publishing API machines are used for running
# the publishing API application and workers.
#
class govuk::node::s_publishing_api (
  $using_amazonmq = false,
  $amazonmq_monitoring_password = '',
  $amazonmq_monitoring_host = '',
) inherits govuk::node::s_base {
  include ::govuk_rbenv::all

  limits::limits { 'root_nofile':
    ensure     => present,
    user       => 'root',
    limit_type => 'nofile',
    both       => 16384,
  }

  limits::limits { 'root_nproc':
    ensure     => present,
    user       => 'root',
    limit_type => 'nproc',
    both       => 1024,
  }

  include nginx

  # The catchall vhost throws a 500, except for healthcheck requests.
  nginx::config::vhost::default { 'default': }

  # Ensure memcached is available to backend nodes
  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '0.0.0.0',
  }

  if ($using_amazonmq) {
    class { "collectd::plugin::rabbitmq":
      monitoring_password => $amazonmq_monitoring_password,
      monitoring_host     => $amazonmq_monitoring_host,
    }
  }
}
