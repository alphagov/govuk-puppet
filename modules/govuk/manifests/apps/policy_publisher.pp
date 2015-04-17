# == Class: govuk::apps::policy_publisher
#
# Policy Publisher exists to create and manage policies and policy
# programmes through the Publishing 2.0 pipeline.
#
# Read more: https://github.com/alphagov/policy-publisher
#
# === Parameters
#
# [*port*]
#   What port should the app run on?
#   Default: 3098
#
class govuk::apps::policy_publisher(
  $enable_future_policies = false,
  $port = 3098,
) {

  include govuk_postgresql::client #installs libpq-dev package needed for pg gem

  validate_bool($enable_future_policies)
  if ($enable_future_policies) {
    govuk::app::envvar {
      "${title}-ENABLE_FUTURE_POLICIES":
        app     => 'policy-publisher',
        varname => 'ENABLE_FUTURE_POLICIES',
        value   => '1';
    }
  }

  govuk::app { 'policy-publisher':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }
}
