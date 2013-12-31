class govuk::python {
  class { '::python':
    pip        => true,
    dev        => true,
    virtualenv => true,
  }

  Package['python-pip'] -> Package <| provider == 'pip' and ensure != absent |>
}
