# == Class: licensify::apps::licensify
#
# Application which serves the Licensify frontend (www.gov.uk/apply-for-a-licence,
# licensify.publishing and uploadlicence.publishing).
#
# === Parameters
#
# [*port*]
#   The TCP port which the app should listen on.
#
# [*aws_ses_access_key*]
#   The access key to authenticate the app to Amazon Simple Email Service.
#
# [*aws_ses_secret_key*]
#   The secret key to authenticate the app to Amazon Simple Email Service.
#
# [*aws_application_form_access_key*]
#   The access key to authenticate the app to Amazon S3.
#
# [*aws_application_form_secret_key*]
#   The secret key to authenticate the app to Amazon S3.
#
# [*environment*]
#   The name of the app's environment, for example 'production', 'staging' or
#   'integration'. This is used to construct the S3 bucket name for PDF
#   storage. (See envvars.pp.)
#
# [*application_secret*]
#   Key for cryptographic functions within the app. See
#   https://github.com/alphagov/licensify/tree/master/backend/app/uk/gov/gds/licensing/admin/controllers/Secured.scala
#
# [*ws_accept_any_certificate*]
#   If true, the app will accept any TLS cert when it connects to the Apto PDF
#   processing server. This is to facilitate connecting to the test PDF
#   processing server, which has a self-signed cert.
#
class licensify::apps::licensify (
  $port = 9000,
  $aws_ses_access_key = '',
  $aws_ses_secret_key = '',
  $aws_application_form_access_key = '',
  $aws_application_form_secret_key = '',
  $environment = '',
  $application_secret = undef,
  $ws_accept_any_certificate = false,
  $alert_5xx_warning_rate = 0.05,
  $alert_5xx_critical_rate = 0.1,
) inherits licensify::apps::base {

  govuk::app { 'licensify':
    app_type                       => 'procfile',
    port                           => $port,
    nginx_extra_config             => template('licensify/nginx_extra'),
    health_check_path              => '/api/licences',
    require                        => File['/etc/licensing'],
    proxy_http_version_1_1_enabled => true,
    log_format_is_json             => true,
    collectd_process_regex         => 'java -Duser.dir=\/data\/vhost\/licensify\..*publishing\.service\.gov\.uk\/licensify-.*',
    nagios_memory_warning          => 1350,
    nagios_memory_critical         => 1500,
    alert_5xx_warning_rate         => $alert_5xx_warning_rate,
    alert_5xx_critical_rate        => $alert_5xx_critical_rate,
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

  if $::aws_migration {
    # On AWS we need Puppet to create the app's config files (whereas on
    # Carrenza/UKCloud the deploy.sh script copies them verbatim from the
    # legacy alphagov-deployments private repo).
    include licensify::apps::configfile
    file { '/etc/licensing/gds-licensify-config.conf':
      ensure  => file,
      content => template('licensify/gds-licensify-config.conf.erb'),
      mode    => '0644',
      owner   => 'deploy',
      group   => 'deploy',
    }
  }

  $app_domain = hiera('app_domain')
  $vhost_name = "uploadlicence.${app_domain}"
  $vhost_escaped = regsubst($vhost_name, '\.', '_', 'G')
  $counter_basename = "${::fqdn_metrics}.nginx_logs.${vhost_escaped}"

  if $::aws_migration {
    # On AWS, we terminate TLS at the load balancer instead of at the app's
    # nginx. licensify-upload-vhost-aws.conf avoids referring to nonexistent
    # certificate files when running on AWS.
    $licensify_upload_vhost_conf = 'licensify/licensify-upload-vhost-aws.conf'
  } else {
    $licensify_upload_vhost_conf = 'licensify/licensify-upload-vhost.conf'
  }
  nginx::config::ssl { $vhost_name: certtype => 'wildcard_publishing' }
  nginx::config::site { $vhost_name: content => template($licensify_upload_vhost_conf) }
  nginx::log {
    "${vhost_name}-json.event.access.log":
      json          => true,
      logstream     => present,
      statsd_metric => "${counter_basename}.http_%{status}",
      statsd_timers => [{metric => "${counter_basename}.time_request",
                          value => 'request_time'}];
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
