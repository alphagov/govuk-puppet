# == Class: govuk::apps::sidekiq_monitoring
#
# App to monitor Sidekiq for multiple GOV.UK apps.
#
# === Parameters
# [*port*]
#   Port that the sidekiq monitoring web frontend listens
#   on and proxies requests to the individual app sidekiq
#   interfaces.
#   Default: 3211
#
# [*nginx_location*]
#   Path on the server where the public folder of the
#   sidekiq-monitoring app can be found.
#   Default: /data/vhost/{value based on app name and domain}/current/public
#
# [*asset_manager_redis_host*]
#   Redis host for Asset Manager Sidekiq.
#   Default: undef
#
# [*asset_manager_redis_port*]
#   Redis port for Asset Manager Sidekiq.
#   Default: undef
#
# [*collections_publisher_redis_host*]
#   Redis host for Collections Publisher Sidekiq.
#   Default: undef
#
# [*collections_publisher_redis_port*]
#   Redis port for Collections Publisher Sidekiq.
#   Default: undef
#
# [*content_audit_tool_redis_host*]
#   Redis host for Content Audit Tool Sidekiq.
#   Default: undef
#
# [*content_audit_tool_redis_port*]
#   Redis port for Content Audit Tool Sidekiq.
#   Default: undef
#
# [*content_data_admin_redis_host*]
#   Redis host for Content Performance Manager Sidekiq.
#   Default: undef
#
# [*content_data_admin_redis_port*]
#   Redis port for Content Performance Manager Sidekiq.
#   Default: undef
#
# [*content_performance_manager_redis_host*]
#   Redis host for Content Performance Manager Sidekiq.
#   Default: undef
#
# [*content_performance_manager_redis_port*]
#   Redis port for Content Performance Manager Sidekiq.
#   Default: undef
#
# [*content_publisher_redis_host*]
#   Redis host for Content Publisher Sidekiq.
#   Default: undef
#
# [*content_publisher_redis_port*]
#   Redis port for Content Publisher Sidekiq.
#   Default: undef
#
# [*content_tagger_redis_host*]
#   Redis host for Content Tagger Sidekiq.
#   Default: undef
#
# [*content_tagger_redis_port*]
#   Redis port for Content Tagger Sidekiq.
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
# [*imminence_redis_host*]
#   Redis host for Imminence Sidekiq.
#   Default: undef
#
# [*imminence_redis_port*]
#   Redis port for Imminence Sidekiq.
#   Default: undef
#
# [*link_checker_api_redis_host*]
#   Redis host for Link Checker API Sidekiq.
#   Default: undef
#
# [*link_checker_api_redis_port*]
#   Redis port for Link Checker API Sidekiq.
#   Default: undef
#
# [*manuals_publisher_redis_host*]
#   Redis host for Manuals Publisher Sidekiq.
#   Default: undef
#
# [*manuals_publisher_redis_port*]
#   Redis port for Manuals Publisher Sidekiq.
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
# [*search_api_redis_host*]
#   Redis host for Search API Sidekiq.
#   Default: undef
#
# [*search_api_redis_port*]
#   Redis port for Search API Sidekiq.
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
# [*specialist_publisher_redis_host*]
#   Redis host for Specialist Publisher Sidekiq.
#   Default: undef
#
# [*specialist_publisher_redis_port*]
#   Redis port for Specialist Publisher Sidekiq.
#   Default: undef
#
# [*support_api_redis_host*]
#   Redis host for Support API Sidekiq.
#   Default: undef
#
# [*support_api_redis_port*]
#   Redis port for Support API Sidekiq.
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
# [*travel_advice_publisher_redis_host*]
#   Redis host for Travel Advice Publisher Sidekiq.
#   Default: undef
#
# [*travel_advice_publisher_redis_port*]
#   Redis port for Travel Advice Publisher Sidekiq.
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
  $port = 3211,
  $nginx_location = undef,
  $asset_manager_redis_host = undef,
  $asset_manager_redis_port = undef,
  $collections_publisher_redis_host = undef,
  $collections_publisher_redis_port = undef,
  $content_audit_tool_redis_host = undef,
  $content_audit_tool_redis_port = undef,
  $content_data_admin_redis_host = undef,
  $content_data_admin_redis_port = undef,
  $content_performance_manager_redis_host = undef,
  $content_performance_manager_redis_port = undef,
  $content_publisher_redis_host = undef,
  $content_publisher_redis_port = undef,
  $content_tagger_redis_host = undef,
  $content_tagger_redis_port = undef,
  $email_alert_api_redis_host = undef,
  $email_alert_api_redis_port = undef,
  $imminence_redis_host = undef,
  $imminence_redis_port = undef,
  $link_checker_api_redis_host = undef,
  $link_checker_api_redis_port = undef,
  $manuals_publisher_redis_host = undef,
  $manuals_publisher_redis_port = undef,
  $publisher_redis_host = undef,
  $publisher_redis_port = undef,
  $publishing_api_redis_host = undef,
  $publishing_api_redis_port = undef,
  $rummager_redis_host = undef,
  $rummager_redis_port = undef,
  $search_api_redis_host = undef,
  $search_api_redis_port = undef,
  $signon_redis_host = undef,
  $signon_redis_port = undef,
  $specialist_publisher_redis_host = undef,
  $specialist_publisher_redis_port = undef,
  $support_api_redis_host = undef,
  $support_api_redis_port = undef,
  $transition_redis_host = undef,
  $transition_redis_port = undef,
  $travel_advice_publisher_redis_host = undef,
  $travel_advice_publisher_redis_port = undef,
  $whitehall_redis_host = undef,
  $whitehall_redis_port = undef,
) {
  $app_name = 'sidekiq-monitoring'
  $app_domain = hiera('app_domain')

  if $::aws_migration {
    $full_domain = $app_name
  } else {
    $full_domain = "${app_name}.${app_domain}"
  }

  if $nginx_location == undef {
    $nginx_location_path = "/data/vhost/${full_domain}/current/public"
  } else {
    $nginx_location_path = $nginx_location
  }

  Govuk::App::Envvar::Redis {
    app => $app_name,
  }

  govuk::app { $app_name:
    app_type           => 'bare',
    command            => 'bundle exec foreman start',
    enable_nginx_vhost => false,
    hasrestart         => true,
  }

  govuk::app::envvar::redis{
    "${app_name}_asset_manager":
      prefix => 'asset_manager',
      host   => $asset_manager_redis_host,
      port   => $asset_manager_redis_port;

    "${app_name}_collections_publisher":
      prefix => 'collections_publisher',
      host   => $collections_publisher_redis_host,
      port   => $collections_publisher_redis_port;

    "${app_name}_content_audit_tool":
      prefix => 'content_audit_tool',
      host   => $content_audit_tool_redis_host,
      port   => $content_audit_tool_redis_port;

    "${app_name}_content_data_admin":
      prefix => 'content_data_admin',
      host   => $content_data_admin_redis_host,
      port   => $content_data_admin_redis_port;

    "${app_name}_content_performance_manager":
      prefix => 'content_performance_manager',
      host   => $content_performance_manager_redis_host,
      port   => $content_performance_manager_redis_port;

    "${app_name}_content_publisher":
      prefix => 'content_publisher',
      host   => $content_publisher_redis_host,
      port   => $content_publisher_redis_port;

    "${app_name}_content_tagger":
      prefix => 'content_tagger',
      host   => $content_tagger_redis_host,
      port   => $content_tagger_redis_port;

    "${app_name}_email_alert_api":
      prefix => 'email_alert_api',
      host   => $email_alert_api_redis_host,
      port   => $email_alert_api_redis_port;

    "${app_name}_imminence":
      prefix => 'imminence',
      host   => $imminence_redis_host,
      port   => $imminence_redis_port;

    "${app_name}_link_checker_api":
      prefix => 'link_checker_api',
      host   => $link_checker_api_redis_host,
      port   => $link_checker_api_redis_port;

    "${app_name}_manuals_publisher":
      prefix => 'manuals_publisher',
      host   => $manuals_publisher_redis_host,
      port   => $manuals_publisher_redis_port;

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

    "${app_name}_specialist_publisher":
      prefix => 'specialist_publisher',
      host   => $specialist_publisher_redis_host,
      port   => $specialist_publisher_redis_port;

    "${app_name}_support_api":
      prefix => 'support_api',
      host   => $support_api_redis_host,
      port   => $support_api_redis_port;

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

  if $search_api_redis_host {
    govuk::app::envvar::redis{
      "${app_name}_search_api":
        prefix => 'search_api',
        host   => $search_api_redis_host,
        port   => $search_api_redis_port;
    }
  }

  nginx::config::site { $full_domain:
    content => template('govuk/sidekiq_monitoring_nginx_config.conf.erb'),
  }
}
