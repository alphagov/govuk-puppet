# == Class: govuk::apps::kibana
#
# Set up the Kibana application
#
# [*port*]
#  Port that Kibana listens on
#
class govuk::apps::kibana($port = '3202') {
  govuk::app { 'kibana':
    app_type => 'rack',
    port     => $port,
  }
}
