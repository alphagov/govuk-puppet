# == Class: monitoring::checks::cloudwatch
#
# Nagios alerts for AWS Elastic cloudwatch.
#
# === Parameters
#
# [*enabled*]
#   This variable enables to define whether to perform Icinga Elastic-cloudwatch checks. [This is set to 'true' by default.]
#
# [*servers*]
#   List of RDS instances.
#
# [*region*]
#   Which AWS region should be checked ['us-east-1','eu-west-1']
#
class monitoring::checks::cloudwatch (
      $enabled = true,
      $servers = [],
      $region = 'eu-west-1',
    ) {

    icinga::plugin { 'check_cloudwatch':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_cloudwatch',
    }

    icinga::check_config { 'check_cloudwatch':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_cloudwatch.cfg',
    }
}
