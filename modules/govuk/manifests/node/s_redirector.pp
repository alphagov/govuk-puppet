# This is the redirector app for redirecting Directgov, Business Link, Agencies, Departments and other sites moving to GOV.UK
class govuk::node::s_redirector inherits govuk::node::s_base {
  class {'nginx':
    server_names_hash_max_size => 16384,
    variables_hash_max_size    => 2048,
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

  @@icinga::check::graphite { "check_nginx_404_redirector_on_${::hostname}":
    target    => "stats.${::fqdn_underscore}.nginx_logs.default.http_404",
    warning   => 5,
    critical  => 10,
    from      => '3minutes',
    desc      => 'nginx 404 rate for redirector',
    host_name => $::fqdn,
  }
  @@icinga::check::graphite { "check_nginx_5xx_redirector_on_${::hostname}":
    target    => "transformNull(stats.${::fqdn_underscore}.nginx_logs.default.http_5xx,0)",
    warning   => 5,
    critical  => 10,
    from      => '3minutes',
    desc      => 'nginx 5xx rate for redirector',
    host_name => $::fqdn,
    notes_url => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html?highlight=nagios#nginx-5xx-rate-too-high-for-many-apps-boxes',
  }
}
