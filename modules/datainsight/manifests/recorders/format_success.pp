class datainsight::recorders::format_success {
  datainsight::recorder { 'format-success': port => '3104' }
  datainsight::recorder::database { 'format_success_db':
    db_name     => 'datainsights_format_success',
    db_password => ''
  }

}