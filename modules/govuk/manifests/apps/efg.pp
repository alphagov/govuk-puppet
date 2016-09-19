# == Class: govuk::apps::efg
#
# Set up the EFG app
#
# === Parameters
#
# [*port*]
#   Port the app runs on
#
# [*vhost_name*]
#   External domain name that EFG should be available on
#
# [*ssl_certtype*]
#   Which certificate EFG should use in each environment
#
# [*devise_pepper*]
#   The key used to encrypt passwords for Devise, passed in as an environment variable
#
# [*devise_secret_key*]
#   The secret_key setting for Devise, passed in as an environment variable
#
# [*exception_recipients*]
#   App config: a string containing comma-separated email addresses that will
#   receive exception notifications
#
# [*lender_support_email*]
#   App config: an email address for support requests
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*secret_token*]
#   The secret token Rails uses to encrypt cookies and stuff like that.
#
class govuk::apps::efg (
  $port = '3019',
  $ssl_certtype,
  $vhost_name,
  $devise_pepper = undef,
  $devise_secret_key = undef,
  $exception_recipients = undef,
  $lender_support_email = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $secret_token = undef,
) {
  validate_string($vhost_name)

  govuk::app { 'efg':
    app_type               => 'rack',
    port                   => $port,
    enable_nginx_vhost     => false,
    health_check_path      => '/healthcheck',
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }

  Govuk::App::Envvar {
    app => 'efg',
  }

  govuk::app::envvar {
    "${title}-EFG_HOST":
      varname => 'EFG_HOST',
      value   => $vhost_name;
    "${title}-DEVISE_PEPPER":
      varname => 'DEVISE_PEPPER',
      value   => $devise_pepper;
    "${title}-DEVISE_SECRET_KEY":
      varname => 'DEVISE_SECRET_KEY',
      value   => $devise_secret_key;
    "${title}-EXCEPTION_RECIPIENTS":
      varname => 'EXCEPTION_RECIPIENTS',
      value   => $exception_recipients;
    "${title}-LENDER_SUPPORT_EMAIL":
      varname => 'LENDER_SUPPORT_EMAIL',
      value   => $lender_support_email;
    "${title}-SECRET_TOKEN":
      varname => 'SECRET_TOKEN',
      value   => $secret_token;
  }

  nginx::config::vhost::proxy { $vhost_name:
    to           => ["localhost:${port}"],
    protected    => false,
    ssl_certtype => $ssl_certtype,
    ssl_only     => true,
  }

  @@icinga::check::graphite { "check_efg_login_failures_${::hostname}":
    target    => 'sumSeries(stats.govuk.app.efg.*.logins.failure)',
    warning   => 10,
    critical  => 15,
    desc      => 'EFG login failures',
    host_name => $::fqdn,
  }

  ramdisk { 'efg_sqlite':
    ensure => present,
    path   => '/var/efg-data',
    atboot => true,
    size   => '512M',
    mode   => '0733',
    owner  => 'deploy',
    group  => 'deploy',
  }
}
