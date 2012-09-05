class mapit {

  include mapit::package, mapit::config, mapit::service
  include nginx

  anchor { ['mapit::start', 'mapit::end']: }

  Anchor['mapit::start'] -> Class['mapit::package'] -> Class['mapit::config']
  Class['mapit::config'] ~> Class['mapit::service'] ~> Anchor['mapit::end']

}
