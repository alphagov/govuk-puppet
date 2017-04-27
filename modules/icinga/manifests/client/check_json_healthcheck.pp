# == Class: icinga::client::check_json_healthcheck
#
# Install a Nagios plugin that alerts when an app's health check reports a
# problem
#
class icinga::client::check_json_healthcheck {

  @icinga::plugin { 'check_json_healthcheck':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_json_healthcheck',
  }

  @icinga::nrpe_config { 'check_json_healthcheck':
    source  => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_json_healthcheck.cfg',
  }
}
