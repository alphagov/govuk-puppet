class mapit {

  include mapit::package, mapit::config, mapit::nginx, mapit::service

  anchor { ['mapit::start', 'mapit::end']: }

  Anchor['mapit::start'] -> Class['mapit::package'] -> Class['mapit::config']
  Class['mapit::config'] ~> Class['mapit::service'] ~> Anchor['mapit::end']
  Class['mapit::nginx'] -> Anchor['mapit::end']

}
