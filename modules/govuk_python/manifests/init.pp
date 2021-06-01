# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_python (
  $govuk_python_version = '2.7.14',
  $govuk_python_setuptools_version = '39.0.1',
  $govuk_python_pip_version = '10.0.1',
) {

  include govuk_python::apt_source
  include govuk_python::python

  ensure_packages(['python3.5', 'python3.5-dev', 'python3-dev'])

  ensure_packages(
    ['govuk-python'],
    {
      ensure  => $govuk_python_version,
      require => Apt::Source['govuk-python'],
    }
  )

  ensure_packages(
    ['govuk-python-setuptools'],
    {
      ensure  => $govuk_python_setuptools_version,
      require => Apt::Source['govuk-python'],
    }
  )

  ensure_packages(
    ['govuk-python-pip'],
    {
      ensure  => $govuk_python_pip_version,
      require => [Apt::Source['govuk-python'], Package['govuk-python']],
    }
  )

  file { '/usr/bin/pip':
    ensure  => 'link',
    target  => '/opt/python2.7/bin/pip',
    require => [Class['python::install'], Package['govuk-python-pip']],
  } -> Package <| provider == 'pip' and ensure != absent |>
}
