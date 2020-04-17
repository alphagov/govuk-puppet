# == Class: licensify::apps::licensify_feed
#
# Application which runs the asynchronous work queue for Licensify.
#
# === Parameters
#
# [*port*]
#   The TCP port which the app should listen on.
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
class licensify::apps::licensify_feed(
  $port = 9400,
  $aws_application_form_access_key = '',
  $aws_application_form_secret_key = '',
  $environment = '',
  $application_secret = undef,
  $ws_accept_any_certificate = false,
) inherits licensify::apps::base {

  if $::aws_migration {
    $collectd_process_regex = 'java -Duser.dir=\/data\/vhost\/licensify-feed\/.*'
  } else {
    $collectd_process_regex = 'java -Duser.dir=\/data\/vhost\/licensify-feed\..*publishing\.service\.gov\.uk\/licensify-feed-.*'
  }

  govuk::app { 'licensify-feed':
    app_type                       => 'procfile',
    port                           => $port,
    vhost_protected                => true,
    require                        => File['/etc/licensing'],
    proxy_http_version_1_1_enabled => true,
    log_format_is_json             => true,
    health_check_path              => '/licence-management/feed/process-applications',
    collectd_process_regex         => $collectd_process_regex,
    nagios_memory_warning          => 1400,
    nagios_memory_critical         => 1500,
  }

  licensify::apps::envvars { 'licensify-feed':
    app                             => 'licensify-feed',
    aws_application_form_access_key => $aws_application_form_access_key,
    aws_application_form_secret_key => $aws_application_form_secret_key,
    environment                     => $environment,
  }

  licensify::build_clean { 'licensify-feed': }


  if $::aws_migration {
    # On AWS we need Puppet to create the app's config files (whereas on
    # Carrenza/UKCloud the deploy.sh script copies them verbatim from the
    # legacy alphagov-deployments private repo).

    include licensify::apps::configfile
    include licensify::apps::certs

    file { '/etc/licensing/gds-licensify-feed-config.conf':
      ensure  => file,
      content => template('licensify/gds-licensify-feed-config.conf.erb'),
      mode    => '0644',
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['licensify-feed'],
    }
  }
}
