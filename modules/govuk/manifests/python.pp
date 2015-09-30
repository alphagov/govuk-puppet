# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::python {

  class { '::python':
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
  }

  Class['python::install'] -> Package <| provider == 'pip' and ensure != absent |>
}
