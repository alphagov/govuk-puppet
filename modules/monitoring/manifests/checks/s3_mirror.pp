# == Class: monitoring::checks::s3_mirror
#
# Icinga alerts for S3 mirror.
#
# === Parameters
#
# [*enabled*]
#   Whether to install the alerts.
#
class monitoring::checks::s3_mirror (
      $enabled = true,
    ) {

    icinga::plugin { 'check_s3_mirror_freshness':
        source  => 'puppet:///modules/monitoring/usr/lib/nagios/plugins/check_s3_mirror_freshness',
    }

    icinga::check_config { 'check_s3_mirror_freshness':
        source  => 'puppet:///modules/monitoring/etc/nagios3/conf.d/check_s3_mirror_freshness.cfg',
    }
}
