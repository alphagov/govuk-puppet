# == Class: govuk_python3
#
# Install python3 package
#
class govuk_python3 (
  $govuk_python_version = '3.6.12',
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {

  apt::source { 'govuk-python3':
    location     => "http://${apt_mirror_hostname}/govuk-python",
    release      => 'stable',
    architecture => $::architecture,
    repos        => 'main',
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  ensure_packages(
    ['govuk-python'],
    {
      ensure  => $govuk_python_version,
      require => Apt::Source['govuk-python3'],
    }
  )
}
