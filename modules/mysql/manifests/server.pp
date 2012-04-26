class mysql::server {
  include mysql::client
  package { ['mysql-server','automysqlbackup']:
    ensure => installed,
  }

  service { 'mysql':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['mysql-server'],
  }

  cron { 'daily sql tarball':
    ensure  => present,
    command => 'for d in `find /var/lib/automysqlbackup/daily -mindepth 1 -maxdepth 1 -type d`; do ls -1tr $d/* | tail -1; done | sudo xargs tar cf /var/lib/automysqlbackup/daily.tar 2>/dev/null',
    user    => 'root',
    minute  => 13,
    hour    => 4,
    require => Service['mysql']
  }

  file { '/var/lib/mysql/my.cnf':
    owner   => 'mysql',
    group   => 'mysql',
    source  => 'puppet:///modules/mysql/my.cnf',
    notify  => Service['mysql'],
    require => Package['mysql-server'],
  }

  file { '/etc/mysql/my.cnf':
    ensure  => 'link',
    target  => '/var/lib/mysql/my.cnf',
    require => File['/var/lib/mysql/my.cnf'],
    notify  => Service['mysql'],
  }

  exec { 'set-mysql-password':
    unless  => "/usr/bin/mysqladmin -uroot -p${mysql_password} status",
    path    => ['/bin', '/usr/bin'],
    command => "mysqladmin -uroot password ${mysql_password}",
    require => Service['mysql'],
  }

}
