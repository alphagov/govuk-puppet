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
# [*enabled*]
#   Feature flag to allow the app to be deployed to an environment.
#   Default: false
#
class govuk::apps::policy_publisher(
  $port = 3098,
  $enabled = false
) {
  if $enabled {
    include govuk_postgresql::client #installs libpq-dev package needed for pg gem
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
}
