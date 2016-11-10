# == Class: govuk_ci::master
#
# Class to manage continuous deployment master
#
class govuk_ci::master {

  include ::govuk_ci::credentials
  include ::govuk_jenkins

  ufw::allow {'jenkins-slave-to-jenkins-master-on-tcp':
    port  => '32768:65535',
    proto => 'tcp',
    ip    => 'any',
  }

  ufw::allow {'jenkins-slave-to-jenkins-master-on-udp':
    port  => '33848',
    proto => 'udp',
    ip    => 'any',
  }

}
