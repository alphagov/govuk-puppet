# == Class: govuk::apps::errbit
#
# Configures Errbit, the open source error catcher that's Airbrake API compliant
#
# === Parameters
#
# [*port*]
#   The port that Errbit is served on.
#   Default: 3029
#
# [*errbit_email_from*]
#   The from address used when errbit notifes us about an error
#
class govuk::apps::errbit(
  $port = 3029,
  $errbit_email_from = 'errbit@example.com',
) {
  govuk::app { 'errbit':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    asset_pipeline     => true,
  }

  Govuk::App::Envvar {
    app => 'errbit',
  }

  govuk::app::envvar {
    'ERRBIT_EMAIL_FROM':
      value => $errbit_email_from;
  }
}
