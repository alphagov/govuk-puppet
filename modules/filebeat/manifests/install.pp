#
class filebeat::install {

  package {'filebeat':
    ensure => $filebeat::package_ensure,
  }

}
