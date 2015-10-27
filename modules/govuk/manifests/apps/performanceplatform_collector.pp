# == Class: govuk::apps::performanceplatform_collector
#
# Performance Platform collector is an application which doesn't run
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
    $app = 'performanceplatform-collector'
    govuk::logstream { "${app}-production-log":
      ensure  => absent,
      logfile => "/data/apps/${app}/shared/log/production.json.log",
      tags    => ['stdout', 'application'],
      fields  => {'application' => $app},
      json    => true,
    }
    logrotate::conf { "govuk-${app}":
      ensure  => absent,
      matches => "/data/apps/${app}/shared/log/*.log",
    }
  }
}
