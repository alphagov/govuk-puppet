# == Class: router::gor
#
# Setup gor traffic replay for GOV.UK
#
# === Parameters
#
# [*replay_targets*]
#   Hash of targets to replay traffic against.
#
# [*add_hosts*]
#   Whether to add the target IP to the hosts file or not.
#   Default: true
#
class router::gor (
  $replay_targets = {},
  $add_hosts = true,
  $input_raw = '127.0.0.1:7999',
  $http_set_header = 'X-Forwarded-Host:',
  $http_disallow_url = []
) {
  validate_hash($replay_targets)

  if $replay_targets == {} {
    $enabled = false
    $gor_hosts_ensure = absent
  } else {
    $enabled = true
    $gor_hosts_ensure = present
  }

  if $add_hosts {
    # These host entries prevent Gor from performing DNS lookups, which occur
    # once for *every* request/goroutine, and can be quite overwhelming.
    $host_defaults = {
      'ensure'  => $gor_hosts_ensure,
      'notify'  => 'Class[Govuk_gor]',
      'comment' => 'Used by Gor. See comments in router::gor.',
    }

    create_resources('host', $replay_targets, $host_defaults)
  }

  class { 'govuk_gor':
    args    => {
      '-input-raw'         => $input_raw,
      '-output-http'       => prefix(keys($replay_targets), 'https://'),
      '-http-allow-method' => [
        'GET', 'HEAD', 'OPTIONS',
      ],
      '-http-set-header'   => $http_set_header,
      '-http-disallow-url' => $http_disallow_url,
    },
    envvars => {
      'GODEBUG' => 'netdns=go',
    },
    enable  => $enabled,
  }
}
