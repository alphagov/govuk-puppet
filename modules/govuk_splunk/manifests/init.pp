# == Class: govuk_splunk
#
# Install, configure and run Splunk universal forwarder
#
# === Parameters:
#
# [*gds_servers*]
#   string of comma delimited "ipaddress:portnumber" of GDS Splunk cloud servers
#
# [*gds_server_cert*]
#   Private certificate and key of forwarder to contact GDS Splunk cloud
#
# [*gds_root_ca_cert*]
#   certificate of certificate authority of GDS Splunk cloud
#
# [*gds_password*]
#   password to use for GDS Splunk cloud
#
# [*gds_cname*]
#   common name of GDS Splunk cloud
#
# [*cyber_servers*]
#   string of comma delimited "ipaddress:portnumber" of Cyber Splunk cloud
#   servers
#
# [*cyber_server_cert*]
#   certificate of Cyber Splunk cloud
#
# [*cyber_root_ca_cert*]
#   certificate of certificate authority of Cyber Splunk cloud
#
# [*cyber_cname*]
#   common name of Cyber Splunk cloud
#
#
class govuk_splunk(
  $gds_servers,
  $gds_server_cert,
  $gds_root_ca_cert,
  $gds_password,
  $gds_cname,
  $cyber_servers,
  $cyber_server_cert,
  $cyber_root_ca_cert,
  $cyber_cname,
) {

  include govuk_splunk::repos

  package { 'splunkforwarder':
    ensure  => latest,
    require => Apt::Source['splunk'],
  }

  file {'/opt/splunkforwarder/var':
    ensure  => directory,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0710',
    recurse => true,
    require => Package['splunkforwarder'],
  }

  package { 'acl':
    ensure  => latest,
  }

  user { 'splunk':
    ensure => present,
  }

  group { 'splunk':
    ensure => present,
  }

  package { 'govuk-splunk-configurator':
    ensure  => latest,
    require => [ Package['splunkforwarder', 'acl'],
                Apt::Source['govuk-splunk-configurator'],
                User['splunk'],
                Group['splunk'],
                ],
  }

  file {'/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/gds_server.pem':
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0600',
    content => $gds_server_cert,
    require => Package['govuk-splunk-configurator'],
    notify  => Service['splunk'],
  }

  file {'/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/gds_cacert.pem':
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0600',
    content => $gds_root_ca_cert,
    require => Package['govuk-splunk-configurator'],
    notify  => Service['splunk'],
  }

  file { '/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/outputs.conf':
    ensure  => present,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0600',
    content => template('govuk_splunk/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/outputs.conf'),
    require => Package['govuk-splunk-configurator'],
    notify  => Service['splunk'],
  }

  file {'/opt/splunkforwarder/etc/apps/100_hf_connect/default/CyberSplunkUFCombinedCertificate.pem':
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0600',
    content => $cyber_server_cert,
    require => Package['govuk-splunk-configurator'],
    notify  => Service['splunk'],
  }

  file {'/opt/splunkforwarder/etc/apps/100_hf_connect/default/CyberSplunkCACertificate.pem':
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0600',
    content => $cyber_root_ca_cert,
    require => Package['govuk-splunk-configurator'],
    notify  => Service['splunk'],
  }

  file { '/opt/splunkforwarder/etc/apps/100_hf_connect/default/outputs.conf':
    ensure  => present,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0600',
    content => template('govuk_splunk/opt/splunkforwarder/etc/apps/100_hf_connect/default/outputs.conf'),
    require => Package['govuk-splunk-configurator'],
    notify  => Service['splunk'],
  }

  file { '/opt/splunkforwarder/etc/apps/govuk_frontend/default/inputs.conf':
    ensure  => present,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0600',
    content => template('govuk_splunk/opt/splunkforwarder/etc/apps/govuk_frontend/default/inputs.conf'),
    require => Package['govuk-splunk-configurator'],
    notify  => Service['splunk'],
  }

  service { 'splunk':
    ensure    => running,
    subscribe => File['/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/gds_server.pem',
                      '/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/gds_cacert.pem',
                      '/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/outputs.conf',
                      '/opt/splunkforwarder/etc/apps/100_hf_connect/default/CyberSplunkUFCombinedCertificate.pem',
                      '/opt/splunkforwarder/etc/apps/100_hf_connect/default/CyberSplunkCACertificate.pem',
                      '/opt/splunkforwarder/etc/apps/100_hf_connect/default/outputs.conf'
                      ],
  }

  @@icinga::check { "check_splunk_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!splunkd',
    service_description => 'splunk universal forwarder running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }

}
