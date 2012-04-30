define base_packages::python::pip_install() {
  exec { "pip install $name":
    command => "pip install $name",
    unless  => "pip freeze | grep $name",
    require => Package['python-pip'],
  }
}
