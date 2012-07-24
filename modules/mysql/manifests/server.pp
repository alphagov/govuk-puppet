class mysql::server($root_password='', $server_id='1') {
  include mysql::server::service
  include mysql::server::package
  class { 'mysql::server::config':
    server_id => $server_id
  }
  class {'mysql::server::monitoring': root_password => $root_password }

  cron { 'daily sql tarball':
    ensure  => present,
    command => 'for d in `find /var/lib/automysqlbackup/daily -mindepth 1 -maxdepth 1 -type d`; do ls -1tr $d/* | tail -1; done | sudo xargs tar cf /var/lib/automysqlbackup/daily.tar 2>/dev/null',
    user    => 'root',
    minute  => 13,
    hour    => 4,
  }
  exec { 'set-mysql-password':
    unless  => "/usr/bin/mysqladmin -uroot -p${root_password} status",
    path    => ['/bin', '/usr/bin'],
    command => "mysqladmin -uroot password ${root_password}",
  }

  anchor { ['mysql::server::start', 'mysql::server::end']: }

  Anchor[mysql::server::start] -> Class[mysql::server::package] -> Class[mysql::server::config] ~> Class[mysql::server::service] ~> Anchor[mysql::server::end]
  Anchor[mysql::server::start] ~> Class[mysql::server::service]
  Class[mysql::server::package] -> Cron['daily sql tarball']
  Class[mysql::server::service] -> Exec['set-mysql-password']
}
