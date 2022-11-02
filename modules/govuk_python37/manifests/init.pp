# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_python37 (
  $govuk_python_version = '3.7',
) {

  include govuk_python37::apt_source
  include govuk_python::python

  Class['python::install'] -> Package <| provider == 'pip' and ensure != absent |>

  ensure_packages(
    ['govuk-python-3.7'],
    {
      ensure  => $govuk_python_version,
      require => Apt::Source['govuk-python37'],
    }
  )
}
