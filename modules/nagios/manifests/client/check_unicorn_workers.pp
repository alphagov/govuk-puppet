# == Class: nagios::client::check_unicorn_workers
#
# Install a Nagios plugin that alerts when the number of unicorn workers is not as expected
#
class nagios::client::check_unicorn_workers {

  @nagios::plugin { 'check_unicorn_workers':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_unicorn_workers',
  }

  @nagios::nrpe_config { 'check_unicorn_workers':
    source  => 'puppet:///modules/nagios/etc/nagios/nrpe.d/check_unicorn_workers.cfg',
  }
}
