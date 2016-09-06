# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class licensify::apps::licensify (
  $port = 9000,
  $aws_ses_access_key = '',
  $aws_ses_secret_key = '',
  $aws_application_form_access_key = '',
  $aws_application_form_secret_key = '',
  $environment = '',
) inherits licensify::apps::base {

  govuk::app { 'licensify':
    app_type                       => 'procfile',
    port                           => $port,
    nginx_extra_config             => template('licensify/nginx_extra'),
    health_check_path              => '/api/licences',
    require                        => File['/etc/licensing'],
    proxy_http_version_1_1_enabled => true,
    log_format_is_json             => true,
  }

  licensify::apps::envvars { 'licensify':
    app                             => 'licensify',
    aws_ses_access_key              => $aws_ses_access_key,
    aws_ses_secret_key              => $aws_ses_secret_key,
    aws_application_form_access_key => $aws_application_form_access_key,
    aws_application_form_secret_key => $aws_application_form_secret_key,
    environment                     => $environment,
  }

  licensify::build_clean { 'licensify': }

  $app_domain = hiera('app_domain')
  $vhost_name = "uploadlicence.${app_domain}"
  $vhost_escaped = regsubst($vhost_name, '\.', '_', 'G')
  $counter_basename = "${::fqdn_metrics}.nginx_logs.${vhost_escaped}"

  nginx::config::ssl { $vhost_name: certtype => 'wildcard_publishing' }
  nginx::config::site { $vhost_name: content => template('licensify/licensify-upload-vhost.conf') }
  nginx::log {
    "${vhost_name}-json.event.access.log":
      json          => true,
      logstream     => present,
      statsd_metric => "${counter_basename}.http_%{@fields.status}",
      statsd_timers => [{metric => "${counter_basename}.time_request",
                          value => '@fields.request_time'}];
    "${vhost_name}-error.log":
      logstream => present;
  }

  statsd::counter { "${counter_basename}.http_500": }

  @@icinga::check::graphite { "check_nginx_5xx_${vhost_name}_on_${::hostname}":
    target    => "transformNull(stats.${counter_basename}.http_5xx,0)",
    warning   => 0.05,
    critical  => 0.1,
    from      => '3minutes',
    desc      => "${vhost_name} high nginx 5xx rate",
    host_name => $::fqdn,
    notes_url => monitoring_docs_url(nginx-5xx-rate-too-high-for-many-apps-boxes),
  }
}
