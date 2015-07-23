# == Class: router::gor
#
# Setup gor traffic replay for GOV.UK
#
# === Parameters
#
# [*staging_host*]
#   Hostname to replay traffic against
#
# [*staging_ip*]
#   IP address for `staging_host` hostname
#
# [*enable_staging*]
#   Boolean to determine if traffic will be replayed against Staging.
#
class router::gor (
  $staging_host,
  $staging_ip,
  $enable_staging = false,
) {
  validate_bool($enable_staging)
  validate_string($staging_host)
  validate_string($staging_ip)

  if $enable_staging and !is_ip_address($staging_ip) {
    fail("Invalid IP address: ${staging_ip}")
  }

  if $enable_staging {
    $gor_targets        = ["https://${staging_host}"]
    $gor_hosts_ensure   = present
  } else {
    $gor_targets        = []
    $gor_hosts_ensure   = absent
  }

  # FIXME: These "fake" host entries serve two purposes:
  #   1. Ensures that the SSL cert on staging, which thinks it is
  #   production, matches the hostname that we connect to.
  #   2. Prevents Gor/Go from performing DNS lookups, which occur once
  #   for *every* request/goroutine, and can be quite overwhelming.
  host {
    $staging_host:
      ensure  => $gor_hosts_ensure,
      ip      => $staging_ip,
      comment => 'Used by Gor. See comments in router::gor.';
  } ~>
  class { 'govuk::gor':
    args   => {
      '-input-raw'          => 'localhost:7999',
      '-output-http'        => $gor_targets,
      '-output-http-method' => [
        'GET', 'HEAD', 'OPTIONS'
      ],
    },
    enable => $enable_staging,
  }
}
