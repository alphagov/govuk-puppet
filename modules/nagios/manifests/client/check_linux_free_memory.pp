# == Class: nagios::client::check_linux_free_memory
#
# Install a Nagios plugin that alerts when the free memory on a box falls below a certain percentage
#
class nagios::client::check_linux_free_memory {

  ensure_packages(['dbus'])

  @nagios::plugin { 'check_linux_free_memory':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_linux_free_memory',
  }

  @nagios::nrpe_config { 'check_linux_free_memory':
    source  => 'puppet:///modules/nagios/etc/nagios/nrpe.d/check_linux_free_memory.cfg',
  }

  @@nagios::check { "check_linux_free_memory_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_linux_free_memory',
    service_description => 'percentage of memory free',
    host_name           => $::fqdn,
  }
}
