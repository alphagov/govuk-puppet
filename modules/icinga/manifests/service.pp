class icinga::service {

  service { 'icinga':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true
  }

#  service { 'icinga-web':
#    ensure     => running,
#    hasstatus  => true,
#    hasrestart => true
# }

}
