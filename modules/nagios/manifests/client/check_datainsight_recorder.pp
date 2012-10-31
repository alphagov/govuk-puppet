class nagios::client::check_datainsight_recorder {

  @nagios::plugin { 'check_datainsight_recorder':
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_datainsight_recorder.rb',
  }
}
