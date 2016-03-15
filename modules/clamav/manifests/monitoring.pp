# == Class: clamav::monitoring
#
# Nagios check to ensure that the daily definitions have been updated by the
# freshclam daemon. As the name suggests, these should update at least every
# day, assuming that ClamAV have published any updates.
#
# There are other definition files but this is a good canary.
#
class clamav::monitoring {
  file { '/usr/local/bin/check_clamav_definitions':
    ensure => present,
    source => 'puppet:///modules/clamav/usr/local/bin/check_clamav_definitions',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  @icinga::nrpe_config { 'check_clamav_definitions':
    source  => 'puppet:///modules/clamav/etc/nagios/nrpe.d/check_clamav_definitions.cfg',
    require => File['/usr/local/bin/check_clamav_definitions'],
  }

  @@icinga::check { "check_clamav_definitions_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_clamav_definitions',
    service_description => 'clamav definitions out of date',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(clamav-definitions-out-of-date),
  }
}
