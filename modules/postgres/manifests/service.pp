class postgres::service {

  service { 'postgresql':
    ensure  => running,
  }

}
