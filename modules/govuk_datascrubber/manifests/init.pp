# == Class: govuk_datascrubber
#
# Install the data scrubber and configure cron to run it
# https://github.com/alphagov/govuk-datascrubber
#
# === Parameters:
#
# [*ensure*]
#   Specify whether to install or remove the tool and its cron job(s)
#   Default is 'latest'
#
# [*mysql_hosts*]
#   List of hostnames of MySQL servers to look for snapshots of
#   Default is 'mysql-primary'
#
# [*postgresql_hosts*]
#   List of hostnames of Postgres servers to look for snapshots of
#   Default is 'postgresql-primary'
#
# [*cron_user*]
#   The account to run the cron job as (default: 'deploy')
#
# [*cron_hour*]
#   To control the schedule.
#   Passed through to the `hour` parameter of the `cron` resource.
#   Default is 20 (8pm)
#
# [*cron_minute*]
#   To control the schedule.
#   Passed through to the `minute` parameter of the `cron` resource
#   Default is 0 (first minute of the hour)
#
# [*share_with*]
#   List of AWS accounts to share the scrubbed snapshots with.
#   Defaults to empty list.
#
# [*aws_region*]
#   The AWS region to operate in
#
# [*alert_hostname*]
#   The hostname to submit Icinga passive check notifications to
#
# [*s3_export_prefix*]
#   The S3 URL prefix to export database dumps to, e.g.:
#   s3://bucketname/prefix
#   will result in dumps being pushed to
#   s3://bucketname/prefix/dbname.sql.gz
#
class govuk_datascrubber (
  $ensure              = 'latest',
  $apt_mirror_hostname = undef,
  $mysql_hosts         = ['mysql-primary'],
  $postgresql_hosts    = ['postgresql-primary'],
  $databases           = ['whitehall', 'email-alert-api', 'publishing-api'],
  $cron_user           = 'deploy',
  $cron_hour           = 20,
  $cron_minute         = 0,
  $share_with          = [],
  $aws_region          = undef,
  $alert_hostname      = 'alert.cluster',
  $s3_export_prefix    = undef,
) {

  if $apt_mirror_hostname {
    apt::source { 'govuk-datascrubber':
      location     => "http://${apt_mirror_hostname}/govuk-datascrubber",
      release      => $::lsbdistcodename,
      architecture => $::architecture,
      key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
      before       => Package['govuk-datascrubber'],
    }
  }

  package { 'govuk-datascrubber':
    ensure => $ensure,
  }

  $cron_command = shellquote(
    flatten([
      'datascrubber',

      '--mysql-hosts', $mysql_hosts,
      '--postgresql-hosts', $postgresql_hosts,

      size($share_with) ? {
        0       => [],
        default => ['--share-with', $share_with],
      },

      $aws_region ? {
        undef   => [],
        default => ['--region', $aws_region],
      },

      $alert_hostname ? {
        undef   => [],
        default => ['--icinga-host', $alert_hostname],
      },

      $s3_export_prefix ? {
        undef   => [],
        default => ['--s3-export', $s3_export_prefix],
      },
    ])
  )

  $ensure_absent_or_present = $ensure ? {
    'absent' => 'absent',
    default  => 'present',
  }

  cron { 'datascrubber' :
    ensure  => $ensure_absent_or_present,
    user    => $cron_user,
    hour    => $cron_hour,
    minute  => $cron_minute,
    command => "PATH=/usr/sbin:/usr/bin:/bin ${cron_command}",
  }

  # The canonical Puppet way to do this would be something like:
  #
  #   $database.each do |db| {
  #     @@icinga::passive_check { "datascrubber-${db}":
  #       ... other parameters ...
  #     }
  #   }
  #
  # The following is a hack to work around the unavailability of iterators in
  # Puppet 3.8 w/o future parser.
  #
  $icinga_checks = parsejson(template('govuk_datascrubber/generate_icinga_checks.erb'))
  create_resources(
    '::govuk_datascrubber::icinga_check',
    $icinga_checks,
    { ensure => $ensure_absent_or_present },
  )
}
