# == Class: govuk::apps::kibana
#
# Set up the Kibana application
#
# [*port*]
#  Port that Kibana listens on
#
class govuk::apps::kibana( $port = '3202' ) {
  govuk::app { 'kibana':
    app_type => 'rack',
    port     => $port,
  }

  $dashboard_directory = '/var/apps/kibana/dashboards'

  file { $dashboard_directory:
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/govuk/apps/kibana/dashboards',
  }
}
