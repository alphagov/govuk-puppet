# == Class: govuk_cdnlogs
#
# Configure rsyslog to receive access logs from our CDN encrypted with TLS.
#
# === Parameters
#
# [*log_dir*]
#   Directory to store CDN logs.
#
# [*rotate_logs_hourly*]
#   Array of service names for which logs should be rotated hourly. Other
#   services will have their logs rotated daily.
#
# [*server_key*]
#   Private key string for rsyslog to use.
#
# [*server_crt*]
#   Certificate string for rsyslog to use.
#
# [*service_port_map*]
#   Hash of service names and ports, e.g.
#     { 'govuk' => 6514 }
#
class govuk_cdnlogs (
  $log_dir,
  $monitoring_enabled = false,
  $rotate_logs_hourly = [],
  $server_key,
  $server_crt,
  $service_port_map,
) {
  validate_hash($service_port_map)
  $ports = join(values($service_port_map), ',')

  $key_file = '/etc/ssl/rsyslog.key'
  $crt_file = '/etc/ssl/rsyslog.crt'

  file { $key_file:
    ensure  => file,
    mode    => '0400',
    owner   => 'root',
    content => $server_key,
    notify  => Class['rsyslog::service'],
  }
  file { $crt_file:
    ensure  => file,
    mode    => '0400',
    owner   => 'root',
    content => $server_crt,
    notify  => Class['rsyslog::service'],
  }

  if !empty($ports) {
    @ufw::allow { 'rsyslog-cdn-logs':
      port => $ports,
    }
  }

  rsyslog::snippet { 'ccc-cdnlogs':
    content => template('govuk_cdnlogs/etc/rsyslog.d/ccc-cdnlogs.conf.erb'),
    require => File[$key_file, $crt_file],
  }

  file { '/etc/logrotate.d/cdnlogs':
    ensure  => file,
    content => template('govuk_cdnlogs/etc/logrotate.d/cdnlogs.erb'),
  }

  file { '/etc/logrotate.cdn_logs_hourly.conf':
    ensure  => file,
    content => template('govuk_cdnlogs/etc/logrotate.cdn_logs_hourly.conf.erb'),
  }

  file { '/etc/cron.hourly/cdn_logs_rotate':
    ensure  => file,
    source  => 'puppet:///modules/govuk_cdnlogs/etc/cron.hourly/cdn_logs_rotate',
    mode    => '0744',
    require => File['/etc/logrotate.cdn_logs_hourly.conf'],
  }

  if $monitoring_enabled {
    if !has_key($service_port_map, 'govuk') {
      fail('Unable to monitor GOV.UK CDN logs, key not present in service_port_map.')
    }

    if !has_key($service_port_map, 'bouncer') {
      fail('Unable to monitor Bouncer CDN logs, key not present in service_port_map.')
    }

    # FIXME: remove this once it has been deployed
    @@icinga::check { "check_cdn_logs_being_streamed_${::hostname}":
      ensure => absent
    }

    @@icinga::check { "check_govuk_cdn_logs_being_streamed_${::hostname}":
      check_command       => "check_nrpe!check_file_age!\"-f ${log_dir}/cdn-govuk.log -c7200 -w3600\"",
      service_description => 'GOV.UK logs are not being received from the CDN',
      host_name           => $::fqdn,
      notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#logs-are-not-being-received-from-the-cdn',
    }

    @@icinga::check { "check_bouncer_cdn_logs_being_streamed_${::hostname}":
      check_command       => "check_nrpe!check_file_age!\"-f ${log_dir}/cdn-bouncer.log -c7200 -w3600\"",
      service_description => 'Bouncer logs are not being received from the CDN',
      host_name           => $::fqdn,
      notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#logs-are-not-being-received-from-the-cdn',
    }
  }

}
