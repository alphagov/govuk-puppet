# == Class: govuk_python::apt_source
#
# govuk-python apt source
#
class govuk_python37::apt_source (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {

  apt::source { 'govuk-python37':
    location     => "http://${apt_mirror_hostname}/govuk-python-3.7",
    release      => 'stable',
    architecture => $::architecture,
    repos        => 'main',
    key          => $apt_mirror_gpg_key_fingerprint,
  }
}
