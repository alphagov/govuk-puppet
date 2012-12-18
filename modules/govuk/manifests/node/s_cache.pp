class govuk::node::s_cache inherits govuk::node::s_base {

  include govuk::htpasswd
  include mirror
  include nginx
  include router::nginx

  class { 'varnish':
    storage_size => '6G',
    default_ttl  => '900',
  }

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  case $::govuk_provider {
    'sky': {
        ufw::allow { 'Allow varnish cache bust from backend machines':
          from => '10.3.0.0/24',
          port => '7999'
        }
    }
    default: {}
  }

  # FIXME: Remove soon
  cron { "logster-cronjob-jetty":
    ensure => 'absent',
  }
}
