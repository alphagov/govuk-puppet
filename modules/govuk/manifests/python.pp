# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::python {

  class { '::python':
    pip        => true,
    dev        => true,
    virtualenv => true,
  }

  Class['python::install'] -> Package <| provider == 'pip' and ensure != absent |>
}
