# == Class: akamai::event_data
#
# Used to log akamai event data, i.e.
# EdgeControl actions, including login date and time, and session information
#
# === Parameters
#
# [*enable*]
#   Whether the crontab should be enabled. It's not desireable to collect
#   logs in/from all environments.
#   Default: true
#
class akamai::event_data(
  $enable = true
) {
  $ensure_real = $enable ? {
    /^false$/ => absent,
    default   => present,
  }
  $ensure_dir = $enable ? {
    /^false$/ => undef,
    default   => directory,
  }

  include python::suds
  include python::pyyaml

  $akamai_webservice_username = extlookup('akamai_webservice_username', 'UNSET')
  $akamai_webservice_password = extlookup('akamai_webservice_password', 'UNSET')

  $akamai_script_dir = '/usr/local/akamai'
  $akamai_script = "${akamai_script_dir}/pull_akamai_event_data.py"

  file { $akamai_script_dir:
    ensure => $ensure_dir,
  }

  file { "${akamai_script_dir}/akamai_logs.yaml":
    ensure  => $ensure_real,
    content => template('akamai/akamai_logs.yaml.erb'),
    mode    => '0600',
  }

  file { "${akamai_script_dir}/last_run":
    ensure => undef,
    mode   => '0644',
  }

  file { $akamai_script:
    ensure  => $ensure_real,
    source  => 'puppet:///modules/akamai/pull_akamai_event_data.py',
    require => File[$akamai_script_dir],
    mode    => '0700',
  }

  cron { 'pull_akamai_event_data':
    ensure  => $ensure_real,
    command => "cd ${akamai_script_dir}; ./pull_akamai_event_data.py | /usr/bin/logger -t akamai_event_data",
    hour    => '1',
    require => File[$akamai_script],
  }

}
