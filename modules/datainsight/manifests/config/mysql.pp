class datainsight::config::mysql {
  class { 'mysql::server':
    root_password => extlookup('mysql_datainsight', '')
  }

  include mysql::client
}