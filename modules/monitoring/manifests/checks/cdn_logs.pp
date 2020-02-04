# == Class: monitoring::checks::cdn_logs
#
# Icinga alerts for Fastly CDN logs.
#
# === Parameters
#
# [*enabled*]
#   Whether to install the alerts.
#
class monitoring::checks::cdn_logs (
      $enabled = true,
    ) {

    icinga::plugin { 'check_cdn_log_s3_freshness':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_cdn_log_s3_freshness',
    }

    icinga::check_config { 'check_cdn_log_s3_freshness':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_cdn_log_s3_freshness.cfg',
    }
}
