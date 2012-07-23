class apt::update {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update';
  }

  Exec['apt-get update'] -> Package <| provider != pip and provider != gem and ensure != absent |>
}
