# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_python (
  $apt_mirror_hostname = undef,
  $govuk_python_version = '2.7.14',
  $govuk_python_setuptools_version = '39.0.1',
  $govuk_python_pip_version = '10.0.1',
){
  class { '::python':
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
  }

  Class['python::install'] -> Package <| provider == 'pip' and ensure != absent |>


  apt::source { 'govuk-python':
    location     => "http://${apt_mirror_hostname}/govuk-python",
    release      => 'stable',
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'govuk-python':
    ensure  => $govuk_python_version,
    require => Apt::Source['govuk-python'],
  }

  package { 'govuk-python-setuptools':
    ensure  => $govuk_python_setuptools_version,
    require => Apt::Source['govuk-python'],
  }

  package { 'govuk-python-pip':
    ensure  => $govuk_python_pip_version,
    require => Apt::Source['govuk-python'],
  }

}
