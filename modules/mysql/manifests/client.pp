class mysql::client {
  package { ['mysql-client','libmysqlclient-dev']:
    ensure => installed,
  }
}
