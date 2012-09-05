class mapit::config {
  file { '/etc/init/mapit.conf':
    ensure  =>  file,
    source  =>  'puppet:///modules/mapit/fastcgi_mapit.conf',
    require =>  [
                  User['mapit'],
                  Exec['unzip_mapit'],
                ]
  }

  file { '/etc/nginx/sites-enabled/mapit':
    ensure  => file,
    source  => 'puppet:///modules/mapit/nginx_mapit.conf'
  }
}
