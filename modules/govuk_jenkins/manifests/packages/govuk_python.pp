# == Class: govuk_jenkins::packages::govuk-python
#
# Installs Python in /usr/local/bin/
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
# [*apt_mirror_gpg_key_fingerprint*]
#   The fingerprint of an APT mirror
#
class govuk_jenkins::packages::govuk_python (
  $govuk_python_version = '2.7.14',
  $govuk_python_setuptools_version = '39.0.1',
  $govuk_python_pip_version = '10.0.1',
){
  include govuk_python::apt_source

  ensure_packages(
    ['govuk-python'],
    {
      ensure  => $govuk_python_version,
      require => Apt::Source['govuk-python'],
    }
  )

  package { 'govuk-python-setuptools':
    ensure  => $govuk_python_setuptools_version,
    require => Apt::Source['govuk-python'],
  }

  package { 'govuk-python-pip':
    ensure  => $govuk_python_pip_version,
    require => Apt::Source['govuk-python'],
  }

}
