# This is the redirector app for redirecting Directgov and Business Link URLs
class govuk::node::redirector_server inherits govuk::node::base {
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
    status         => '444',
    status_message => '',
  }

  @logster::cronjob { "nginx-redirector":
    args => "--metric-prefix redirector NginxGangliaLogster /var/log/nginx/access.log",
  }

  @@nagios::check { "check_nginx_404_redirector_on_${::hostname}":
    check_command       => "check_ganglia_metric!redirector_nginx_http_404!5!10",
    service_description => "nginx 404 rate for redirector",
    host_name           => $::fqdn,
  }
  @@nagios::check { "check_nginx_5xx_redirector_on_${::hostname}":
    check_command       => "check_ganglia_metric!redirector_nginx_http_5xx!5!10",
    service_description => "nginx 5xx rate for redirector",
    host_name           => $::fqdn,
  }
}
