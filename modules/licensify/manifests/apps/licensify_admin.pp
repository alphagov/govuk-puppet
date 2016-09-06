# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class licensify::apps::licensify_admin(
  $port = 9500,
  $aws_ses_access_key = '',
  $aws_ses_secret_key = '',
  $aws_application_form_access_key = '',
  $aws_application_form_secret_key = '',
  $environment = '',
) inherits licensify::apps::base {

  govuk::app { 'licensify-admin':
    app_type                       => 'procfile',
    port                           => $port,
    health_check_path              => '/healthcheck',
    json_health_check              => true,
    require                        => File['/etc/licensing'],
    proxy_http_version_1_1_enabled => true,
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
}
