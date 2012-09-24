class datainsight::recorders::weekly_reach {
  datainsight::recorder { 'weekly-reach': port => '3102' }
  datainsight::recorder::database { 'weekly_reach_db':
    db_name     => 'datainsight_weekly_reach',
    db_password => ''
  }

}