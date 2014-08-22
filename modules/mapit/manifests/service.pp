# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
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
