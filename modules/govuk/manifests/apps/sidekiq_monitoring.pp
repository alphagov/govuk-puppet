# == Class: govuk::apps::sidekiq_monitoring
#
# App to monitor Sidekiq for multiple GOV.UK apps.
#
# === Parameters
#
# [*content_tagger_redis_host*]
#   Redis host for Content Tagger Sidekiq.
#   Default: undef
#
# [*content_tagger_redis_port*]
#   Redis port for Content Tagger Sidekiq.
#   Default: undef
#
# [*dfid_transition_redis_host*]
#   Redis host for DFID Transition Sidekiq.
#   Default: undef
#
# [*dfid_transition_redis_port*]
#   Redis port for DFID Transition Sidekiq.
#   Default: undef
#
# [*email_alert_api_redis_host*]
#   Redis host for Email Alert API Sidekiq.
#   Default: undef
#
# [*email_alert_api_redis_port*]
#   Redis port for Email Alert API Sidekiq.
#   Default: undef
#
# [*email_campaign_api_redis_host*]
#   Redis host for Email Campaign API Sidekiq.
#   Default: undef
#
# [*email_campaign_api_redis_port*]
#   Redis port for Email Campaign API Sidekiq.
#   Default: undef
#
# [*imminence_redis_host*]
#   Redis host for Imminence Sidekiq.
#   Default: undef
#
# [*imminence_redis_port*]
#   Redis port for Imminence Sidekiq.
#   Default: undef
#
# [*publisher_redis_host*]
#   Redis host for Publisher Sidekiq.
#   Default: undef
#
# [*publisher_redis_port*]
#   Redis port for Publisher Sidekiq.
#   Default: undef
#
# [*publishing_api_redis_host*]
#   Redis host for Publishing API Sidekiq.
#   Default: undef
#
# [*publishing_api_redis_port*]
#   Redis port for Publishing API Sidekiq.
#   Default: undef
#
# [*rummager_redis_host*]
#   Redis host for Rummager Sidekiq.
#   Default: undef
#
# [*rummager_redis_port*]
#   Redis port for Rummager Sidekiq.
#   Default: undef
#
# [*signon_redis_host*]
#   Redis host for Signon Sidekiq.
#   Default: undef
#
# [*signon_redis_port*]
#   Redis port for Signon Sidekiq.
#   Default: undef
#
# [*travel_advice_publisher_redis_host*]
#   Redis host for Travel Advice Publisher Sidekiq.
#   Default: undef
#
# [*travel_advice_publisher_redis_port*]
#   Redis port for Travel Advice Publisher Sidekiq.
#   Default: undef
#
# [*transition_redis_host*]
#   Redis host for Transition Sidekiq.
#   Default: undef
#
# [*transition_redis_port*]
#   Redis port for Transition Sidekiq.
#   Default: undef
#
# [*whitehall_redis_host*]
#   Redis host for Whitehall Sidekiq.
#   Default: undef
#
# [*whitehall_redis_port*]
#   Redis port for Whitehall Sidekiq.
#   Default: undef
#
class govuk::apps::sidekiq_monitoring (
  $content_tagger_redis_host = undef,
  $content_tagger_redis_port = undef,
  $dfid_transition_redis_host = undef,
  $dfid_transition_redis_port = undef,
  $email_alert_api_redis_host = undef,
  $email_alert_api_redis_port = undef,
  $email_campaign_api_redis_host = undef,
  $email_campaign_api_redis_port = undef,
  $imminence_redis_host = undef,
  $imminence_redis_port = undef,
  $publisher_redis_host = undef,
  $publisher_redis_port = undef,
  $publishing_api_redis_host = undef,
  $publishing_api_redis_port = undef,
  $rummager_redis_host = undef,
  $rummager_redis_port = undef,
  $signon_redis_host = undef,
  $signon_redis_port = undef,
  $travel_advice_publisher_redis_host = undef,
  $travel_advice_publisher_redis_port = undef,
  $transition_redis_host = undef,
  $transition_redis_port = undef,
  $whitehall_redis_host = undef,
  $whitehall_redis_port = undef,
) {
  $app_name = 'sidekiq-monitoring'
  $app_domain = hiera('app_domain')
  $full_domain = "${app_name}.${app_domain}"

  Govuk::App::Envvar::Redis {
    app => $app_name,
  }

  govuk::app { $app_name:
    app_type           => 'bare',
    command            => 'bundle exec foreman start',
    enable_nginx_vhost => false,
    hasrestart         => true,
  }

  govuk::app::envvar::redis {
    "${app_name}_content_tagger":
      prefix => 'content_tagger',
      host   => $content_tagger_redis_host,
      port   => $content_tagger_redis_port;

    "${app_name}_dfid_transition":
      prefix => 'dfid_transition',
      host   => $dfid_transition_redis_host,
      port   => $dfid_transition_redis_port;

    "${app_name}_email_alert_api":
      prefix => 'email_alert_api',
      host   => $email_alert_api_redis_host,
      port   => $email_alert_api_redis_port;

    "${app_name}_email_campaign_api":
      prefix => 'email_campaign_api',
      host   => $email_campaign_api_redis_host,
      port   => $email_campaign_api_redis_port;

    "${app_name}_imminence":
      prefix => 'imminence',
      host   => $imminence_redis_host,
      port   => $imminence_redis_port;

    "${app_name}_publisher":
      prefix => 'publisher',
      host   => $publisher_redis_host,
      port   => $publisher_redis_port;

    "${app_name}_publishing_api":
      prefix => 'publishing_api',
      host   => $publishing_api_redis_host,
      port   => $publishing_api_redis_port;

    "${app_name}_rummager":
      prefix => 'rummager',
      host   => $rummager_redis_host,
      port   => $rummager_redis_port;

    "${app_name}_signon":
      prefix => 'signon',
      host   => $signon_redis_host,
      port   => $signon_redis_port;

    "${app_name}_transition":
      prefix => 'transition',
      host   => $transition_redis_host,
      port   => $transition_redis_port;

    "${app_name}_travel_advice_publisher":
      prefix => 'travel_advice_publisher',
      host   => $travel_advice_publisher_redis_host,
      port   => $travel_advice_publisher_redis_port;

    "${app_name}_whitehall":
      prefix => 'whitehall',
      host   => $whitehall_redis_host,
      port   => $whitehall_redis_port;
  }

  nginx::config::site { $full_domain:
    content => template('govuk/sidekiq_monitoring_nginx_config.conf.erb'),
  }
}
