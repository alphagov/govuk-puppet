# == Class: govuk::apps::dfid_transition
#
# Helps in managing the DFID research outputs import by allowing
# us to enqueue transition operations (such as downloading the
# outputs' PDFs). This 'app' has a shelf life which expires
# when dfid-transition does.
#
# Read more: https://github.com/alphagov/dfid-transition
#
# === Parameters
#
# [*port*]
#   Not used.
#   Default: 9999
#
# [*enabled*]
#   Whether the app should exist
#   Default: false
#
# [*enabled_procfile_worker*]
#   Whether the procfile worker is enabled
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#   Default: undef
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*redis_host*]
#   Redis host for Sidekiq and AttachmentIndex.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq and AttachmentIndex.
#   Default: undef
#
class govuk::apps::dfid_transition (
  $port = 3124,
) {
  $app_name = 'dfid-transition'

  govuk::procfile::worker {$app_name:
    ensure => absent,
  }

  govuk::app { $app_name:
    ensure             => absent,
    app_type           => 'procfile',
    port               => $port,
    enable_nginx_vhost => true,
  }
}
