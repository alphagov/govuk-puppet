# == Class: mapit::config
#
# Sets up config for Mapit
#
# === Parameters
#
# [*django_secret_key*]
#   Secret key to use in Mapit's Django app.
#
# [*postgresql_password*]
#   Password for the `mapit` PostgreSQL user.
#
class mapit::config (
  $django_secret_key,
  $postgresql_password,
) {
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
    content =>  template('mapit/general.yml.erb'),
    require =>  [
                  User['mapit'],
                  Exec['unzip_mapit'],
                ]
  }
}
