# == Class: icinga::client::check_file_not_exists
#
# Install a Nagios plugin that can alert when a file does not exist
#
class icinga::client::check_file_not_exists {

  @icinga::plugin { 'check_file_not_exists':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_file_not_exists',
  }

  @icinga::nrpe_config { 'check_file_not_exists':
    source => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_file_not_exists.cfg',
  }
}
