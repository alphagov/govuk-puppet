#
class filebeat::service {

  service { 'filebeat':
    ensure => $filebeat::service_ensure,
    enable => $filebeat::service_enable,
  }

  @@icinga::check { "check_filebeat_running_${::hostname}":
    ensure              => $filebeat::service_ensure,
    check_command       => 'check_nrpe!check_proc_running!filebeat',
    service_description => 'filebeat running',
    host_name           => $::fqdn,
  }

}
