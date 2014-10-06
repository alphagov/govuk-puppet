# == Class: govuk_cdnlogs
#
# Configure rsyslog to receive access logs from our CDN encrypted with TLS.
#
# === Parameters
#
# [*log_dir*]
#   Directory to store CDN logs.
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

  if $monitoring_enabled {
    if !has_key($service_port_map, 'govuk') {
      fail('Unable to monitor GOV.UK CDN logs, key not present in service_port_map.')
    }

    @@icinga::check { "check_cdn_logs_being_streamed_${::hostname}":
      check_command       => "check_nrpe!check_file_age!\"-f ${log_dir}/cdn-govuk.log -c7200 -w3600\"",
      service_description => 'Logs are not being received from the CDN',
      host_name           => $::fqdn,
      notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#logs-are-not-being-received-from-the-cdn',
    }
  }

}
