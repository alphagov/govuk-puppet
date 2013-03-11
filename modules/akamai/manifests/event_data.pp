# == Class: akamai::event_data
#
# Used to log akamai event data, i.e.
# EdgeControl actions, including login date and time, and session information
#
class akamai::event_data {

  $akamai_webservice_username = extlookup('akamai_webservice_username')
  $akamai_webservice_password = extlookup('akamai_webservice_password')
  $akamai_script_dir = '/usr/local/akamai'

  package { 'suds':
    ensure   => present,
    provider => 'pip',
  }

  file { $akamai_script_dir:
    ensure => directory,
  }

  file { "${akamai_script_dir}/bin":
    ensure  => directory,
    require => File[$akamai_script_dir]
  }

  file { "${akamai_script_dir}/bin/pull_event_data_access_logs.py":
    ensure  => present,
    content => template('akamai/pull_event_data_access_logs.py.erb'),
    require => [Package['suds'], File["${akamai_script_dir}/bin"]],
    mode    => '0700',
  }

}
