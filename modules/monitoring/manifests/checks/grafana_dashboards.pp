# == Class: monitoring::checks::grafana_dashboards
#
# Single Nagios alert for Grafana dashboards that aren't in version control
class monitoring::checks::grafana_dashboards (
) {
  $app_domain_internal = hiera('app_domain_internal')

  icinga::plugin { 'check_grafana_dashboards':
    source => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_grafana_dashboards',
  }

  icinga::check_config { 'check_grafana_dashboards':
    content => template('monitoring/check_grafana_dashboards.cfg.erb'),
    require => File['/usr/lib/nagios/plugins/check_grafana_dashboards'],
  }

  icinga::check { 'check_grafana_dashboards':
    check_command       => 'check_grafana_dashboards',
    use                 => 'govuk_normal_priority',
    host_name           => $::fqdn,
    check_interval      => 7d,
    service_description => 'At least 1 Grafana dashboard is not in version control',
    require             => Icinga::Check_config['check_grafana_dashboards'],
    notes_url           => monitoring_docs_url(grafana-dashboards),
    action_url          => "https://grafana.${app_domain_internal}",
  }
}
