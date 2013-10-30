# == Class: icinga::client::check_upstart_status
#
# Install a Nagios plugin that can alert when upstart is down
#
class icinga::client::check_upstart_status {

  ensure_packages(['dbus'])

  @icinga::plugin { 'check_upstart_status':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_upstart_status',
  }

  @icinga::nrpe_config { 'check_upstart_status':
    source  => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_upstart_status.cfg',
  }
}
