# == Class: nagios::client::check_path_age
#
# Install a Nagios plugin that can alert when the modified time of a file or
# directory exceeds N number of days.
#
class nagios::client::check_file_size {
  @nagios::plugin { 'check_file_size.py':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_file_size.py',
  }

  @nagios::nrpe_config { 'check_file_size':
    source  => 'puppet:///modules/nagios/etc/nagios/nrpe.d/check_file_size.cfg',
  }
}
