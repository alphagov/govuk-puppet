# == Class: nagios::client::check_path_age
#
# Install a Nagios plugin that can alert when the modified time of a file or
# directory exceeds N number of days.
#
class nagios::client::check_path_age {
  @nagios::plugin { 'check_path_age.py':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_path_age.py',
  }

  @nagios::nrpe_config { 'check_path_age':
    source  => 'puppet:///modules/nagios/etc/nagios/nrpe.d/check_path_age.cfg',
  }
}
