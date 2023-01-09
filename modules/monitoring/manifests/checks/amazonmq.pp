# == Class: monitoring::checks::amazonmq
#
# Nagios alerts for AmazonMQ.
# Each consuming_app defines its own checks in
# govuk::apps::(app name)::amazonmq_monitoring
#
# These files are included in this class, for each app
# name in monitoring::checks::amazonmq::consuming_apps 
# 
# === Parameters
#
# [*enabled*]
#   This variable enables to define whether to perform Account SLO checks. [This is set to 'true' by default.]
class monitoring::checks::amazonmq (
      $enabled = true,
      $region = 'eu-west-1',
      $consuming_apps = [],
    ) {

  validate_array($consuming_apps)

  if $enabled {
    icinga::check_config { 'check_amazonmq_consumers':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_amazonmq_consumers.cfg',
    }

    icinga::check_config { 'check_amazonmq_messages':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_amazonmq_messages.cfg',
    }

    # convert the given array of app names into an array of classes to include
    $consuming_app_monitoring_classes = regsubst(regsubst($consuming_apps, '^', 'govuk::apps::'), '$', '::amazonmq_monitoring')
    include $consuming_app_monitoring_classes
  }
}
