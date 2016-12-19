# == Class: Icinga::Client::Check_jenkins_agent
#
# Checks the online/offline status of a Jenkins agent by calling the
# API from the master.
#
class icinga::client::check_jenkins_agent {
  ensure_packages('jq', {'ensure' => 'present'})

  @icinga::plugin { 'check_jenkins_agent':
    source  => 'puppet:///modules/icinga/usr/lib/nagios/plugins/check_jenkins_agent',
  }

  @icinga::nrpe_config { 'check_jenkins_agent':
    source => 'puppet:///modules/icinga/etc/nagios/nrpe.d/check_jenkins_agent.cfg',
  }
}
