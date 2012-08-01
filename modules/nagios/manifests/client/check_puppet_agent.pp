class nagios::client::check_puppet_agent {
  file { '/usr/lib/nagios/plugins/check_puppet_agent':
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0755',
    source  => 'puppet:///modules/nagios/usr/lib/nagios/plugins/check_puppet_agent',
    require => Package['nagios-nrpe-plugin'],
  }

  @@nagios::check { "check_puppet_agent_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_puppet_agent',
    service_description => "Check puppet has run recently on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
