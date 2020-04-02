# == Class: govuk_prometheus
#
# Install and run Prometheus Server
#
class govuk_prometheus (
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {

  include ::nginx

  $cors_headers = '
  add_header "Access-Control-Allow-Methods" "GET, OPTIONS";
  add_header "Access-Control-Allow-Headers" "origin, authorization, accept";
'
  nginx::config::vhost::default { 'default': }

  nginx::config::vhost::proxy { 'prometheus':
    to           => ['localhost:9090'],
    root         => '/',
    protected    => false,
    extra_config => $cors_headers,
  }

  apt::source { 'govuk-prometheus':
    location     => "http://${apt_mirror_hostname}/govuk-prometheus",
    release      => 'stable',
    architecture => $::architecture,
    repos        => 'main',
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'prometheus':
    ensure  => latest,
    require => Apt::Source['govuk-prometheus'],
  }

  service { 'prometheus':
    ensure  => running,
    require => File['/etc/prometheus/prometheus.yml'],
  }

  file { '/etc/prometheus/prometheus.yml':
    ensure  => present,
    source  => 'puppet:///modules/govuk_prometheus/etc/prometheus/prometheus.yml',
    mode    => '0755',
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  @@icinga::check { "check_prometheus_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!prometheus',
    service_description => 'prometheus running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }
}
