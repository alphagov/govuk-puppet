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
  $errbit_secret_key_base = 'f258ed69266dc8ad0ca79363c3d2f945c388a9c5920fc9a1ae99a98fbb619f135001c6434849b625884a9405a60cd3d50fc3e3b07ecd38cbed7406a4fccdb59c', # This is the default in the errbit/errbit repo
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

  $app_domain = hiera('app_domain')

  govuk::app::envvar {
    'ERRBIT_EMAIL_FROM':
      value => $errbit_email_from;
    'ERRBIT_HOST':
      value => "errbit.${app_domain}";
    'SECRET_KEY_BASE':
      value => $errbit_secret_key_base;
  }
}
