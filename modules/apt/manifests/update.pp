class apt::update {
  exec { 'apt-get update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }
}
