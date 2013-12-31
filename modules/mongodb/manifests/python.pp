class mongodb::python {
  package { 'pymongo':
    ensure   => present,
    provider => 'pip';
  }
}
