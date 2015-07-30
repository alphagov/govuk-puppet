# == Class: grafana::dashboards
#
# Set up monitoring dashboards for grafana.
#
class grafana::dashboards {
  $dashboard_directory = '/etc/grafana/dashboards'

  file { $dashboard_directory:
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/grafana/dashboards',
  }
}
