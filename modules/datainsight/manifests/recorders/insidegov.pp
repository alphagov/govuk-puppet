class datainsight::recorders::insidegov {
  datainsight::recorder { 'insidegov': port => '3106' }
  datainsight::recorder::database { 'insidegov_db':
    db_name     => 'datainsight_insidegov',
    db_password => ''
  }

}
