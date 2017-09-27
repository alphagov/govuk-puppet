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
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*oauth_id*]
#   The application's OAuth ID from Signon
#
# [*oauth_secret*]
#   The application's OAuth Secret from Signon
#
class govuk::apps::errbit(
  $port = '3029',
  $errbit_email_from = 'errbit@example.com',
  $errbit_secret_key_base = 'f258ed69266dc8ad0ca79363c3d2f945c388a9c5920fc9a1ae99a98fbb619f135001c6434849b625884a9405a60cd3d50fc3e3b07ecd38cbed7406a4fccdb59c', # This is the default in the errbit/errbit repo
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
) {
  govuk::app { 'errbit':
    app_type               => 'rack',
    port                   => $port,
    vhost_ssl_only         => true,
    health_check_path      => '/healthcheck',
    log_format_is_json     => true,
    asset_pipeline         => true,
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }
}
