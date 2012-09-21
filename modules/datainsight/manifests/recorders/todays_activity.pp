class datainsight::recorders::todays_activity {
  datainsight::recorder { 'todays-activity': port => '3103' }
  datainsight::recorder::database { 'todays_activity_db':
    db_name     => 'datainsights_todays_activity',
    db_password => ''
  }

}