# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define licensify::apps::envvars(
  $app,
  $aws_ses_access_key,
  $aws_ses_secret_key,
) {

  Govuk::App::Envvar {
    app => $app,
  }
  govuk::app::envvar { "${app}-LANG":
    varname => 'LANG',
    value   => 'en_GB.UTF-8',
  }
  govuk::app::envvar { "${app}-AWS_ACCESS_KEY_ID":
    varname => 'AWS_ACCESS_KEY_ID',
    value   => $aws_ses_access_key,
  }
  govuk::app::envvar { "${app}-AWS_SECRET_KEY":
    varname => 'AWS_SECRET_KEY',
    value   => $aws_ses_secret_key,
  }
}
