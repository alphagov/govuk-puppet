# == Class: icinga::client::check_unicorn_workers
#
# Install a Nagios plugin that alerts when the number of unicorn workers is not as expected
#
class icinga::client::check_unicorn_workers {

  @icinga::plugin { 'check_unicorn_workers':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_unicorn_workers',
  }

  @icinga::nrpe_config { 'check_unicorn_workers':
    source  => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_unicorn_workers.cfg',
  }
}
