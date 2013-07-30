class apt::monitoring {
  # Provides `notify-reboot-required` which is referenced in the `postinst`
  # of some packages in order to request that the system be rebooted at a
  # convenient time. Required by the `check_reboot_required` alert, but
  # still beneficial to have on nodes that aren't monitored by Nagios.
  package { 'update-notifier-common':
    ensure => present,
  }

  @nagios::nrpe_config { 'check_apt_updates':
    source => 'puppet:///modules/apt/etc/nagios/nrpe.d/check_apt_updates.cfg',
  }
  @nagios::plugin { 'check_apt_updates':
    source => 'puppet:///modules/apt/usr/lib/nagios/plugins/check_apt_updates',
  }
  @@nagios::check { "check_apt_updates_${::hostname}":
    check_command       => 'check_nrpe!check_apt_updates!200 1000',
    service_description => 'outstanding package updates',
    host_name           => $::fqdn,
  }

  @nagios::nrpe_config { 'check_reboot_required':
    source => 'puppet:///modules/apt/etc/nagios/nrpe.d/check_reboot_required.cfg',
  }
  @nagios::plugin { 'check_reboot_required':
    source  => 'puppet:///modules/apt/usr/lib/nagios/plugins/check_reboot_required',
    require => Package['update-notifier-common'],
  }
  @@nagios::check { "check_reboot_required_${::hostname}":
    check_command       => 'check_nrpe!check_reboot_required!30 0',
    service_description => 'reboot required by apt',
    host_name           => $::fqdn,
  }
}
