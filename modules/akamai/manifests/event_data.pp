# == Class: akamai::event_data
#
# Used to log akamai event data, i.e.
# EdgeControl actions, including login date and time, and session information
#
class akamai::event_data {

  $akamai_webservice_username = extlookup('akamai_webservice_username')
  $akamai_webservice_password = extlookup('akamai_webservice_password')

  $akamai_script_dir = '/usr/local/akamai'
  $akamai_script = "${akamai_script_dir}/pull_akamai_event_data.py"

  package { ['suds', 'pyyaml']:
    ensure   => present,
    provider => 'pip',
  }

  file { $akamai_script_dir:
    ensure => directory,
  }

  file { "${akamai_script_dir}/akamai_logs.yaml":
    content => template('akamai/akamai_logs.yaml.erb'),
    mode    => '0600',
  }

  file { "${akamai_script_dir}/last_run":
    mode   => '0644',
  }


  file { $akamai_script:
    ensure  => present,
    source  => 'puppet:///modules/akamai/pull_akamai_event_data.py',
    require => [Package['suds', 'pyyaml'], File[$akamai_script_dir]],
    mode    => '0700',
  }

  cron { 'pull_akamai_event_data':
    ensure  => present,
    command => "cd ${akamai_script_dir}; ./pull_akamai_event_data.py | /usr/bin/logger -t akamai_event_data",
    hour    => '1',
    require => File[$akamai_script],
  }

}
