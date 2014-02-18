define datainsight::recorder::database($db_name, $db_password, $db_user = 'datainsight') {
  include datainsight::config::mysql

  mysql::db { $db_name:
    user     => $db_user,
    host     => '%',
    password => $db_password,
  }
}
