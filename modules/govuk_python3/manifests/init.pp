# == Class: govuk_python3
#
# Install python3 package
#
class govuk_python3 (
  $govuk_python_version = '3.6.12',
) {
  include govuk_python::apt_source

  ensure_packages(
    ['govuk-python'],
    {
      ensure  => $govuk_python_version,
      require => Apt::Source['govuk-python'],
    }
  )
}
