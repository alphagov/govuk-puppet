# FIXME: remove once cleaned up from servers
class govuk::apps::fco_services(
  $port = 3050,
) {

  govuk::app { 'fco-services':
    ensure   => absent,
    app_type => 'rack',
    port     => $port,
  }
}
