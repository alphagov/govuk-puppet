class mapit::service {
  service { 'mapit':
      ensure    =>  running,
      provider  =>  upstart,
      subscribe =>  [
                      File['/etc/init/mapit.conf'],
                      File['/data/vhost/mapit/mapit/conf/general.yml']
                    ],
      require   =>  [
                      File['/etc/init/mapit.conf'],
                      Exec['unzip_mapit']
                    ]
  }
}
