# == Class: govuk::apps::efg_training
#
# Set up the EFG_TRAINING app
#
# === Parameters
#
# [*port*]
#   Port the app runs on
#
# [*vhost_name*]
#   External domain name that EFG_TRAINING should be available on
#
# [*ssl_certtype*]
#   Which certificate EFG_TRAINING should use in each environment
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
class govuk::apps::efg_training (
  $port = '3126',
  $ssl_certtype,
  $vhost_name,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
) {
  validate_string($vhost_name)

  govuk::app { 'efg_training':
    app_type               => 'rack',
    port                   => $port,
    enable_nginx_vhost     => false,
    health_check_path      => '/healthcheck',
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }

  govuk::app::envvar { 'Training_EFG_HOST':
    app     => 'efg-training',
    value   => $vhost_name,
    varname => 'EFG_HOST',
  }

  nginx::config::vhost::proxy { $vhost_name:
    to           => ["localhost:${port}"],
    protected    => false,
    ssl_certtype => $ssl_certtype,
    ssl_only     => true,
  }

  @@icinga::check::graphite { "check_efg_training_login_failures_${::hostname}":
    target    => 'sumSeries(stats.govuk.app.efg_training.*.logins.failure)',
    warning   => 10,
    critical  => 15,
    desc      => 'EFG_TRAINING login failures',
    host_name => $::fqdn,
  }

  ramdisk { 'efg_training_sqlite':
    ensure => present,
    path   => '/var/efg-training-data',
    atboot => true,
    size   => '512M',
    mode   => '0733',
    owner  => 'deploy',
    group  => 'deploy',
  }
}
