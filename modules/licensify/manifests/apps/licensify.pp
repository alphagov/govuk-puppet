# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class licensify::apps::licensify (
  $port = 9000,
  $aws_ses_access_key = '',
  $aws_ses_secret_key = '',
  $vhost_protected = false,
) inherits licensify::apps::base {

  govuk::app { 'licensify':
    app_type           => 'procfile',
    port               => $port,
    vhost_protected    => $vhost_protected,
    nginx_extra_config => template('licensify/nginx_extra'),
    health_check_path  => '/api/licences',
    require            => File['/etc/licensing'],
  }

  licensify::apps::envvars { 'licensify':
    app                => 'licensify',
    aws_ses_access_key => $aws_ses_access_key,
    aws_ses_secret_key => $aws_ses_secret_key,
  }

  nginx::config::vhost::licensify_upload{ 'licensify':}
  licensify::build_clean { 'licensify': }
}
