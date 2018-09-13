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
class govuk_datascrubber (
  $ensure              = 'latest',
  $apt_mirror_hostname = undef,
  $mysql_hosts         = ['mysql-primary'],
  $postgresql_hosts    = ['postgresql-primary'],
  $cron_user           = 'deploy',
  $cron_hour           = 20,
  $cron_minute         = 0,
  $share_with          = [],
  $aws_region          = undef,
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
    ])
  )

  $cron_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'present',
  }

  cron { 'datascrubber' :
    ensure  => $cron_ensure,
    user    => $cron_user,
    hour    => $cron_hour,
    minute  => $cron_minute,
    command => $cron_command,
  }

  # The canonical Puppet way to do this would be something like:
  #
  #   $mysql_hosts.each do |host| {
  #     @@icinga::passive_check { "datascrubber-${host}":
  #       ... other parameters ...
  #     }
  #   }
  #
  # The following is a hack to work around the unavailability of iterators in
  # Puppet 3.8 w/o future parser.
  #
  $icinga_checks = parsejson(template('govuk_datascrubber/generate_icinga_checks.erb'))
  create_resources('::govuk_datascrubber::icinga_check', $icinga_checks)

}
