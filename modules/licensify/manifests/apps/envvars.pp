define licensify::apps::envvars($app) {
  $aws_access_key_id = extlookup('aws_access_key_id', '')
  $aws_secret_key = extlookup('aws_secret_key', '')

  Govuk::App::Envvar {
    app => $app,
  }
  govuk::app::envvar { "${app}-LANG":
    varname => 'LANG',
    value   => 'en_GB.UTF-8',
  }
  govuk::app::envvar { "${app}-AWS_ACCESS_KEY_ID":
    varname => 'AWS_ACCESS_KEY_ID',
    value   => $aws_access_key_id,
  }
  govuk::app::envvar { "${app}-AWS_SECRET_KEY":
    varname => 'AWS_SECRET_KEY',
    value   => $aws_secret_key,
  }
}
