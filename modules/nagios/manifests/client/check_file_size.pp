# == Class: nagios::client::check_file_size
#
# Install a Nagios plugin that can alert when the size of a file is less than a
# minimum number of bytes.
#
class nagios::client::check_file_size {
  @nagios::plugin { 'check_file_size.py':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_file_size.py',
  }

  @nagios::nrpe_config { 'check_file_size':
    source  => 'puppet:///modules/nagios/etc/nagios/nrpe.d/check_file_size.cfg',
  }
}
