class mapit::service {
  service { 'mapit':
      ensure    =>  running,
      provider  =>  upstart,
      subscribe =>  File['/etc/init/mapit.conf'],
      require   =>  [
                      File['/etc/init/mapit.conf'],
                      Exec['unzip_mapit']
                    ]
  }
}
