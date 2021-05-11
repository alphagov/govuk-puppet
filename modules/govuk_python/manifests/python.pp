# == Class: govuk_python::python
#
# govuk-python python
#
class govuk_python::python {

  class { '::python':
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
  }

}
