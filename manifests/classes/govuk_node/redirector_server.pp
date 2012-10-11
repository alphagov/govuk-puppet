# This is the redirector app for redirecting Directgov and Business Link URLs
class govuk_node::redirector_server inherits govuk_node::base {
  include nginx
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
    status => '444',
  }

  @logster::cronjob { "nginx-redirector":
    args => "--metric-prefix redirector NginxGangliaLogster /var/log/nginx/access.log",
  }

  @@nagios::check { "check_nginx_404_redirector_on_${::hostname}":
    check_command       => "check_ganglia_metric!redirector_nginx_http_404!0.05!0.1",
    service_description => "check nginx 404 rate for redirector",
    host_name           => "${::govuk_class}-${::hostname}",
  }
  @@nagios::check { "check_nginx_5xx_redirector_on_${::hostname}":
    check_command       => "check_ganglia_metric!redirector_nginx_http_5xx!0.05!0.1",
    service_description => "check nginx error rate for redirector",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
