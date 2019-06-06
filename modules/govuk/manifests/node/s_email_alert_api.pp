# == Class: govuk::node::email_alert_api
#
# Email Alert API machine definition. Email Alert API machines are used for running
# the email alert API and email alert service applications and workers.
#
class govuk::node::s_email_alert_api inherits govuk::node::s_base {
  include ::govuk_rbenv::all

  include govuk_aws_xray_daemon

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

  if ( $::aws_migration and ($::aws_environment != 'production') ) {
    concat { '/etc/nginx/lb_healthchecks.conf':
      ensure => present,
      before => Nginx::Config::Vhost::Default['default'],
    }
    $extra_config = 'include /etc/nginx/lb_healthchecks.conf;'
  } else {
    $extra_config = ''
  }

  # If we miss all the apps, throw a 500 to be caught by the cache nginx
  nginx::config::vhost::default { 'default':
    extra_config => $extra_config,
  }

  # Ensure memcached is available to backend nodes
  include collectd::plugin::memcached
  class { 'memcached':
    max_memory => '12%',
    listen_ip  => '127.0.0.1',
  }
}
