# == Class: govuk_python::apt_source
#
# govuk-python apt source
#
class govuk_python3::apt_source (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {

  apt::source { 'govuk-python3':
    location     => "http://${apt_mirror_hostname}/govuk-python3",
    release      => 'stable',
    architecture => $::architecture,
    repos        => 'main',
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
