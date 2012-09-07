define datainsight::recorder::database($db_name, $db_password, $db_user = 'datainsight') {

  include datainsight::config::mysql

  mysql::server::db {  "{$db_name}_database":
    user          => $db_user,
    password      => $db_password,
    name          => $db_name,
    host          => 'localhost',
    root_password => 'axohXZ6iu5jahain9Choh0AhCh5thaa5'
  }

}