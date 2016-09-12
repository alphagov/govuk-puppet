# == Class: icinga::client::check_procfile_workers
#
# Install a Nagios plugin that alerts when the number of procfile workers is not as expected
#
class icinga::client::check_procfile_workers {

  @icinga::plugin { 'check_procfile_workers':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_procfile_workers',
  }

  @icinga::nrpe_config { 'check_procfile_workers':
    source  => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_procfile_workers.cfg',
  }
}
