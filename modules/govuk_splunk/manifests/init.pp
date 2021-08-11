# == Class: govuk_splunk
#
# Remove Splunk universal forwarder
#
# === Parameters:
#
class govuk_splunk(
) {

  include govuk_splunk::repos

  package { 'splunkforwarder':
    ensure  => absent,
    require => [ Apt::Source['splunk'],
                Service['splunk'],
               ],
  }

  file {'/opt/splunkforwarder/var':
    ensure  => absent,
    recurse => true,
    require => Service['splunk'],
  }

  user { 'splunk':
    ensure => absent,
    require => Service['splunk'],
  }

  group { 'splunk':
    ensure => absent,
    require => Service['splunk'],
  }

  package { 'govuk-splunk-configurator':
    ensure  => absent,
    require => [ Package['splunkforwarder', 'acl'],
                Apt::Source['govuk-splunk-configurator'],
                User['splunk'],
                Group['splunk'],
                ],                 
  }

  file {'/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/gds_server.pem':
    ensure  => absent,
    require => Service['splunk'],
  }

  file {'/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/gds_cacert.pem':
    ensure  => absent,
    require => Service['splunk'],
  }

  file { '/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/outputs.conf':
    ensure  => absent,
    require => Service['splunk'],
  }

  file {'/opt/splunkforwarder/etc/apps/100_hf_connect/default/CyberSplunkUFCombinedCertificate.pem':
    ensure  => absent,
    require => Service['splunk'],
  }

  file {'/opt/splunkforwarder/etc/apps/100_hf_connect/default/CyberSplunkCACertificate.pem':
    ensure  => absent,
    require => Service['splunk'],
  }

  file { '/opt/splunkforwarder/etc/apps/100_hf_connect/default/outputs.conf':
    ensure  => absent,
    require => Service['splunk'],
  }

  service { 'splunk':
    ensure => stopped,
    enable => false,
    hasstatus => enable,
    subscribe => File['/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/gds_server.pem',
                      '/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/gds_cacert.pem',
                      '/opt/splunkforwarder/etc/apps/100_gds_splunkcloud/default/outputs.conf',
                      '/opt/splunkforwarder/etc/apps/100_hf_connect/default/CyberSplunkUFCombinedCertificate.pem',
                      '/opt/splunkforwarder/etc/apps/100_hf_connect/default/CyberSplunkCACertificate.pem',
                      '/opt/splunkforwarder/etc/apps/100_hf_connect/default/outputs.conf'
                      ],
  }

}
