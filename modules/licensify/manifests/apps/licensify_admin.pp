# == Class: licensify::apps::licensify_admin
#
# Application which serves the Licensify admin backend
# (licensify-admin.publishing).
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
class licensify::apps::licensify_admin(
  $port = 9500,
  $aws_ses_access_key = '',
  $aws_ses_secret_key = '',
  $aws_application_form_access_key = '',
  $aws_application_form_secret_key = '',
  $environment = '',
  $application_secret = undef,
) inherits licensify::apps::base {

  if $::aws_migration {
    $collectd_process_regex = 'java -Duser.dir=\/data\/vhost\/licensify-admin\/.*'
  } else {
    $collectd_process_regex = 'java -Duser.dir=\/data\/vhost\/licensify-admin\..*publishing\.service\.gov\.uk\/licensify-admin-.*'
  }

  govuk::app { 'licensify-admin':
    app_type                       => 'procfile',
    port                           => $port,
    health_check_path              => '/healthcheck',
    json_health_check              => true,
    require                        => File['/etc/licensing'],
    proxy_http_version_1_1_enabled => true,
    log_format_is_json             => true,
    collectd_process_regex         => $collectd_process_regex,
    nagios_memory_warning          => 1350,
    nagios_memory_critical         => 1500,
  }

  licensify::apps::envvars { 'licensify-admin':
    app                             => 'licensify-admin',
    aws_ses_access_key              => $aws_ses_access_key,
    aws_ses_secret_key              => $aws_ses_secret_key,
    aws_application_form_access_key => $aws_application_form_access_key,
    aws_application_form_secret_key => $aws_application_form_secret_key,
    environment                     => $environment,
  }

  licensify::build_clean { 'licensify-admin': }

  if $::aws_migration {
    # On AWS we need Puppet to create the app's config files (whereas on
    # Carrenza/UKCloud the deploy.sh script copies them verbatim from the
    # legacy alphagov-deployments private repo).

    include licensify::apps::configfile
    include licensify::apps::certs

    file { '/etc/licensing/gds-licensify-admin-config.conf':
      ensure  => file,
      content => template('licensify/gds-licensify-admin-config.conf.erb'),
      mode    => '0644',
      owner   => 'deploy',
      group   => 'deploy',
      notify  => Service['licensify-admin'],
    }
  }
}
