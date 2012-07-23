class mysql::server::slave ($database, $user, $password, $host, $root_password, $master_host, $remote_host='%') {
  class { 'mysql::server':
    root_password=> $root_password
  }

  Class['mysql::server'] -> Db["$database"]->Exec['create-dump-from-master']
  db{"$database":
    user          => $user,
    password      => $password,
    host          => $host,
    root_password => $root_password,
    remote_host   => $remote_host
  }
  file { '/opt/mysql-dump/':
    ensure => directory
  }
  exec { 'create-dump-from-master':
    creates => "/opt/mysql-dump/dump.sql",
    require =>File["/opt/mysql-dump/"],
    command => "/usr/bin/mysqldump -h ${master_host} -u${user} -p'${password}' --database ${database} > /opt/mysql-dump/dump.sql",
  }
}
