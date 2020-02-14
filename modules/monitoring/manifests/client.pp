# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class monitoring::client (
  $graphite_hostname = 'graphite.cluster',
  $alert_hostname = 'alert.cluster',
) {

  include monitoring::client::apt
  include icinga::client
  include nsca
  include auditd
  include collectd
  include collectd::plugin::tcp

  exec { 'gds-nagios-plugins':
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    command => 'pip uninstall -y setuptools-pep8 gds-nagios-plugins || true',
    require => Package['update-notifier-common'],
  }

  class { 'statsd':
    graphite_hostname => $graphite_hostname,
  }

  file { '/usr/local/bin/notify_passive_check':
    ensure  => present,
    mode    => '0755',
    content => template('govuk/notify_passive_check.erb'),
  }
}
