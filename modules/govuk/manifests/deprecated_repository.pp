# == Class: govuk::deprecated_repository
#
# Please see the following page in the opsmanual:
#
# https://github.gds/pages/gds/opsmanual/infrastructure/debian-packaging.html#deprecated-s3-repo
#
# No feature flag is provided to switch this back to the old S3 source. If
# our mirror goes down then the repo should just be disabled temporarily.
#
class govuk::deprecated_repository {
  apt::source { 'govuk-s3deprecated-current':
    location     => 'http://apt.production.alphagov.co.uk/govuk/s3deprecated/current',
    release      => 'current',
    repos        => 'main',
    architecture => $::architecture,
    key          => '37E3ACBB',
  }
}
