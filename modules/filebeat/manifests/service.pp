#
class filebeat::service {

  service { 'filebeat':
    ensure => $filebeat::service_ensure,
    enable => $filebeat::service_enable,
  }

}
