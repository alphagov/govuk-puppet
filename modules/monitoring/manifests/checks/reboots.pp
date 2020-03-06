# == Class: monitoring::checks::reboots
#
# Single Nagios alert for reboots being required in the environment
#
class monitoring::checks::reboots {
  icinga::plugin { 'check_reboots_required':
    source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_reboots_required',
    require => File['/usr/local/bin/govuk_node_list'],
  }

  icinga::check_config { 'check_reboots_required':
    source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_reboots_required.cfg',
    require => File['/usr/lib/nagios/plugins/check_reboots_required'],
  }

  icinga::check { 'check_reboots_required':
      check_command       => 'check_reboots_required',
      use                 => 'govuk_normal_priority',
      host_name           => $::fqdn,
      check_interval      => 60,
      service_description => 'At least 1 machine requires reboots due to apt updates',
      notes_url           => monitoring_docs_url(rebooting-machines),
      require             => Icinga::Check_config['check_reboots_required'],
  }
}
