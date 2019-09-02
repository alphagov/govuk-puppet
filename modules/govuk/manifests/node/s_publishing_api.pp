# == Class: govuk::node::publishing_api
#
# Publishing API machine definition. Publishing API machines are used for running
# the publishing API application and workers.
#
class govuk::node::s_publishing_api inherits govuk::node::s_base {
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

  if $::aws_migration {
    concat { '/etc/nginx/lb_healthchecks.conf':
      ensure => present,
      before => Nginx::Config::Vhost::Default['default'],
    }
    $extra_config = 'include /etc/nginx/lb_healthchecks.conf;'
  } else {
    $extra_config = ''
  }

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    # For AWS staging and production, use the external domain name when
    # constructing the URI for talking to Signon. This is needed while Signon
    # is still in Carrenza.
    $app_domain = hiera('app_domain')
    govuk_envvar {
      'PLEK_SERVICE_SIGNON_URI': value => "https://signon.${app_domain}";
    }
  }

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default':
    extra_config => $extra_config,
  }

  # Ensure memcached is available to backend nodes
  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '0.0.0.0',
  }
}
