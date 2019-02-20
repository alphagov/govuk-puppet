# == Class: govuk_search::gor
#
# Dump POST traffic to file so that it can be replayed. This means we have a simple
# way to recover from failure as we can restore the last backup and then replay the
# traffic (POST requests are for data insert/update only)
#
# Also optionally replays traffic, in real-time, to a given list of
# target hosts.  This is a temporary measure so we can replay
# Whitehall and Search Admin updates from Rummager to Search API
# during the migration.
#
# Traffic can then be replayed by follow the guide at:
# https://github.com/buger/goreplay/wiki/Capturing-and-replaying-traffic
#
# === Parameters
#
# [*enabled*]
#   Boolean to determine if Search traffic will be saved; defaults to false.
#
# [*output_path*]
#   File location for files to be saved to.
#
#   If the output path contains an `_` then either the filename need to end in an `_`
#   or output-file-append needs to be set to true for the filename generation to work
#   as expected.
#
# [*replay_target_hosts*]
#   Hosts to replay traffic to; defaults to an empty list.
#
# [*port*]
#   Port to record traffic from; defaults to 3009.
#
class govuk_search::gor (
  $output_path = '/var/log/gor_dump',
  $enabled = false,
  $replay_target_hosts = [],
  $port = '3009',
) {

  validate_bool($enabled)

  if($enabled) {
    validate_re($output_path, '^/.*')

    file { $output_path:
      ensure => 'directory',
      owner  => root,
      group  => root,
      mode   => '0755',
    }

    @logrotate::conf { 'govuk_search_logs':
      matches => "${output_path}/*.log",
    }

    $output_file = "${output_path}/%Y%m%d.log"

    class { 'govuk_gor':
      args    => {
        '-input-raw'          => ":${port}",
        '-output-file'        => $output_file,
        '-output-file-append' => true,
        '-http-allow-method'  => ['POST', 'DELETE'],
        '-output-http'        => $replay_target_hosts,
        '-http-original-host' => '',
      },
      envvars => {
        'GODEBUG' => 'netdns=go',
      },
      enable  => $enabled,
    }
  }
}
