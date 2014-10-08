# == Class: bouncer::gor
#
# Setup gor traffic replay for the Bouncer application
#
# === Parameters
#
# [*enable_staging*]
#   Boolean to determine if traffic will be replayed against Staging; defaults to false.
#
# [*staging_ip*]
#   IP address of the Bouncer application in Staging; defaults to undef.
#
class bouncer::gor (
  $enable_staging = false,
) {

  $staging_ip     = '37.26.91.5'

  validate_bool($enable_staging)

  if $enable_staging {
    $gor_enable         = true
    # Bouncer only receives traffic over HTTP (port 80)
    $gor_targets        = ["http://${staging_ip}"]
  } else {
    $gor_enable         = false
    $gor_targets        = []
  }

  class { 'govuk::gor':
    args    => {
      '-input-raw'          => 'localhost:80',
      '-output-http'        => $gor_targets,
      '-output-http-method' => [
        'GET', 'HEAD', 'OPTIONS'
      ],
    },
    enable  => $gor_enable,
    version => '0.7.0-9026155~ppa1~precise',
  }
}
