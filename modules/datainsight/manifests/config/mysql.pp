class datainsight::config::mysql {
  class { 'mysql::server':
    root_password => 'axohXZ6iu5jahain9Choh0AhCh5thaa5'
  }

  class {'mysql::client' : }
}