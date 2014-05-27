class govuk::apps::need_o_tron::db (
  $mysql_need_o_tron_new = '',
){

  mysql::db { 'need_o_tron_production':
    user     => 'need_o_tron',
    host     => '%',
    password => $mysql_need_o_tron_new,
  }
}
