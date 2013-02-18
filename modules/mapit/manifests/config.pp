class mapit::config {
  file { '/etc/init/mapit.conf':
    ensure  =>  file,
    source  =>  'puppet:///modules/mapit/fastcgi_mapit.conf',
    require =>  [
                  User['mapit'],
                  Exec['unzip_mapit'],
                ]
  }

  file { '/data/vhost/mapit/mapit/conf/general.yml':
    ensure  =>  file,
    source  =>  'puppet:///modules/mapit/general.yml',
    require =>  [
                  User['mapit'],
                  Exec['unzip_mapit'],
                ]
  }

  nginx::config::ssl { 'wildcard_alphagov':
    certtype => 'wildcard_alphagov'
  }
  nginx::config::site { 'mapit':
    source  => 'puppet:///modules/mapit/nginx_mapit.conf'
  }
  nginx::log {  [
                'mapit.access.log',
                'mapit.error.log'
                ]:
  }
}
