# == Class: router::gor
#
# Setup gor traffic replay for GOV.UK
#
# === Parameters
#
# [*replay_targets*]
#   Hash of targets to replay traffic against.
#
class router::gor (
  $replay_targets = {},
) {
  validate_hash($replay_targets)

  if $replay_targets == {} {
    $enabled = false
    $gor_hosts_ensure = absent
  } else {
    $enabled = true
    $gor_hosts_ensure = present
  }

  # These host entries prevent Gor from performing DNS lookups, which occur
  # once for *every* request/goroutine, and can be quite overwhelming.
  $host_defaults = {
    'ensure'  => $gor_hosts_ensure,
    'notify'  => 'Class[Govuk_gor]',
    'comment' => 'Used by Gor. See comments in router::gor.',
  }

  create_resources('host', $replay_targets, $host_defaults)

  class { 'govuk_gor':
    args   => {
      '-input-raw'          => 'localhost:7999',
      '-output-http'        => prefix(keys($replay_targets), 'https://'),
      '-output-http-method' => [
        'GET', 'HEAD', 'OPTIONS',
      ],
    },
    enable => $enabled,
  }
}
