#
class filebeat::service {

  service { 'filebeat':
    ensure => $filebeat::service_ensure,
    enable => $filebeat::service_enable,
  }

  # If service_enable set to true ensure there is a check
  if $filebeat::service_enable {
    $check_ensure = 'present'
  } else {
    $check_ensure = 'absent'
  }

  @@icinga::check { "check_filebeat_running_${::hostname}":
    ensure              => $check_ensure,
    check_command       => 'check_nrpe!check_proc_running!filebeat',
    service_description => 'filebeat not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }

}
