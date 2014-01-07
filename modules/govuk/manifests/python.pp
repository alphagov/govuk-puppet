class govuk::python {
  class { '::python':
    pip        => true,
    dev        => true,
    virtualenv => true,
  }

  Class['python::install'] -> Package <| provider == 'pip' and ensure != absent |>
}
