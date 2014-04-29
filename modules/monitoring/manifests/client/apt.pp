class monitoring::client::apt {
  @icinga::nrpe_config { 'check_apt_security_updates':
    source => 'puppet:///modules/monitoring/etc/nagios/nrpe.d/check_apt_security_updates.cfg',
  }
  @icinga::plugin { 'check_apt_security_updates':
    ensure => absent
  }
  @@icinga::check { "check_apt_security_updates_${::hostname}":
    check_command              => 'check_nrpe!check_apt_security_updates!0 0',
    service_description        => 'outstanding security updates',
    host_name                  => $::fqdn,
    attempts_before_hard_state => 24, # Wait 24hrs to allow unattended-upgrades to run first
    check_interval             => 60, # Save cycles, apt-get update only runs every 30m
    retry_interval             => 60,
    notes_url                  => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#outstanding-security-updates',
  }

  @icinga::nrpe_config { 'check_reboot_required':
    source => 'puppet:///modules/monitoring/etc/nagios/nrpe.d/check_reboot_required.cfg',
  }
  @icinga::plugin { 'check_reboot_required':
    ensure => absent
  }
  @@icinga::check { "check_reboot_required_${::hostname}":
    check_command       => 'check_nrpe!check_reboot_required!30 0',
    service_description => 'reboot required by apt',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#reboot-required-by-apt',
  }
}
