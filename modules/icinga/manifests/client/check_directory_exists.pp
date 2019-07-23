# == Class: icinga::client::check_directory_exists
#
# Install a Nagios plugin that can alert when a directory does not exist
#
class icinga::client::check_directory_exists {
  @icinga::plugin { 'check_directory_exists':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_directory_exists',
  }

  @icinga::nrpe_config { 'check_directory_exists':
    source => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_directory_exists.cfg',
  }
}
