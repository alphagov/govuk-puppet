# This is the redirector app for redirecting Directgov and Business Link URLs
class govuk::node::s_redirector inherits govuk::node::s_base {
  class {'nginx':
    server_names_hash_max_size => 1024,
  }
  include nginx::php
  include govuk::apps::redirector

  # We're going to be running the redirector integration tests *from* the
  # redirector server itself -- they take 5m to run this way, and over 40m if we
  # have to wait for the network overhead of running them from Jenkins. In order
  # to do this, Crypt::SSLeay needs to be installed.
  #
  # At some point in the future when we're confident of the redirector, this can
  # be removed.
  package { 'libcrypt-ssleay-perl':
    ensure => present,
  }

  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
    extra_config   => "
    location /healthcheck {
      default_type application/json;
      return 200 '{\"healthcheck\": \"ok\"}\n';
    }
    ",
  }

  @logster::cronjob { "nginx-redirector":
    file    => '/var/log/nginx/access.log',
    prefix  => 'nginx_logs.redirector',
  }

  # FIXME: keepLastValue() because logster only runs every 2m.
  @@nagios::check { "check_nginx_404_redirector_on_${::hostname}":
    check_command       => "check_graphite_metric_since!keepLastValue(${::fqdn_underscore}.nginx_logs.redirector.http_404)!3minutes!5!10",
    service_description => "nginx 404 rate for redirector",
    host_name           => $::fqdn,
  }
  @@nagios::check { "check_nginx_5xx_redirector_on_${::hostname}":
    check_command       => "check_graphite_metric_since!keepLastValue(${::fqdn_underscore}.nginx_logs.redirector.http_5xx)!3minutes!5!10",
    service_description => "nginx 5xx rate for redirector",
    host_name           => $::fqdn,
  }
}
