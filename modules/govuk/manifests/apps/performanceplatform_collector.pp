# == Class: govuk::apps::performanceplatform_collectors
#
# Performance Platform collectors is an application which doesn't run
# as a service. It's triggered by cron periodically to push data to
# Backdrop.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
class govuk::apps::performanceplatform_collector (
  $enabled = false,
) {

  if $enabled {
    include govuk::deploy

    $app_domain = hiera('app_domain')

    # vhost_full is a confusingly-named parameter. It's used to create
    # the /data/vhost/{$appname} directory at deploy time.
    govuk::app::package { 'performanceplatform-collector':
      vhost_full => "performanceplatform-collector.${app_domain}",
    }
  }
}
