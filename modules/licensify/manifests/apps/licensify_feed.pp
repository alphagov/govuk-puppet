# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class licensify::apps::licensify_feed(
  $port = 9400,
  $aws_ses_access_key = '',
  $aws_ses_secret_key = '',
  $aws_application_form_access_key = '',
  $aws_application_form_secret_key = '',
  $environment = '',
) inherits licensify::apps::base {

  govuk::app { 'licensify-feed':
    app_type                       => 'procfile',
    port                           => $port,
    vhost_protected                => true,
    require                        => File['/etc/licensing'],
    proxy_http_version_1_1_enabled => true,
    health_check_path              => '/licence-management/feed/process-applications',
  }

  licensify::apps::envvars { 'licensify-feed':
    app                             => 'licensify-feed',
    aws_ses_access_key              => $aws_ses_access_key,
    aws_ses_secret_key              => $aws_ses_secret_key,
    aws_application_form_access_key => $aws_application_form_access_key,
    aws_application_form_secret_key => $aws_application_form_secret_key,
    environment                     => $environment,
  }

  licensify::build_clean { 'licensify-feed': }
}
