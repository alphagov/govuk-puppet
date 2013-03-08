class akamai::event_data {

  $akamai_webservice_username = extlookup("akamai_webservice_username")
  $akamai_webservice_password = extlookup("akamai_webservice_password")

  package { 'suds':
    ensure => present,
    provider => 'pip',
  }

  file { "/var/lib/akamai":
    ensure => directory,
  }

  file { "/var/lib/akamai/pull_event_data_access_logs.py":
    content => template("akamai/pull_event_data_access_logs.py.erb"),
    ensure => present,
    require => [Package['suds'], File['/var/lib/akamai']],
  }

}
