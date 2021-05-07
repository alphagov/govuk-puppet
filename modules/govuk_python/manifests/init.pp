# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_python (
  $govuk_python_version = '2.7.14',
) {

  include govuk_python::apt_source
  include govuk_python::python

  Class['python::install'] -> Package <| provider == 'pip' and ensure != absent |>

  ensure_packages(['python3.5', 'python3.5-dev', 'python3-dev'])

  ensure_packages(
    ['govuk-python'],
    {
      ensure  => $govuk_python_version,
      require => Apt::Source['govuk-python'],
    }
  )
}
