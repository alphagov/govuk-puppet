class mongodb::python {
  package { 'pymongo':
    ensure   => '2.6.3',
    provider => 'pip';
  }
}
