# == Class: icinga::client::check_linux_free_memory
#
# Install a Nagios plugin that alerts when the free memory on a box falls below a certain percentage
#
class icinga::client::check_linux_free_memory {

  ensure_packages(['dbus'])

  @icinga::plugin { 'check_linux_free_memory':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_linux_free_memory',
  }

  @icinga::nrpe_config { 'check_linux_free_memory':
    source  => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_linux_free_memory.cfg',
  }

  @@icinga::check { "check_linux_free_memory_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_linux_free_memory',
    service_description => 'percentage of memory free',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#free-memory-warning-on-backend',
  }
}
