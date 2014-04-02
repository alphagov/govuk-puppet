# == Class: govuk::ppa
#
# === Parameters
#
# [*path*]
#   Path that constitutes the last part of the repository. This can be used
#   to present a different snapshot to an environment, e.g. `preview`
#   Default: `production`
#
# [*use_mirror*]
#   Whether to use our snapshotted mirror of the PPA. Things may break if
#   you disable this, because package versions may have changed and PPAs
#   only allow you to access the latest version.
#   Default: true
#
class govuk::ppa (
  $path = 'production',
  $use_mirror = true,
) {
  validate_bool($use_mirror)
  if $use_mirror {
    apt::source { 'govuk-ppa':
      location     => "http://apt.production.alphagov.co.uk/govuk/ppa/${path}",
      architecture => $::architecture,
      key          => '37E3ACBB',
    }
  } else {
    apt::ppa { 'ppa:gds/govuk': }
  }
}
