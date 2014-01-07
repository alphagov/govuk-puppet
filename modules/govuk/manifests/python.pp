class govuk::python {
  # FIXME: Use an internal package for python-pip on Lucid due to 01b7f11.
  # But otherwise favour the mainline package of a lower version number,
  # since we can't just remove that repo from all Precise machines.
  include govuk::repository

  if $::lsbdistcodename != 'Lucid' {
    apt::pin { 'ignore_pip_from_s3_if_not_lucid':
      packages   => 'python-pip',
      originator => 'Ubuntu',
      priority   => 1001,
      before     => Class['::python'],
    }
  }

  class { '::python':
    pip        => true,
    dev        => true,
    virtualenv => true,
  }

  Class['python::install'] -> Package <| provider == 'pip' and ensure != absent |>
}
