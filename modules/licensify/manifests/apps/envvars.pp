# == Define: licensify::apps::envvars
#
# Defines environment variables which are common to all three Licensify applications.
#
# === Parameters
#
# [*app*]
#   The application we're deploying. In addition to licensify in this context it can also be admin or feed
#
# [*aws_application_form_access_key*]
#    The AWS access key used by this licensify application to access application form storage
#
# [*aws_application_form_secret_key*]
#    The AWS secret key used by this licensify application to access application form storage
#
define licensify::apps::envvars(
  $app,
  $aws_application_form_access_key,
  $aws_application_form_secret_key,
  $environment,
  $aws_application_form_bucket_name = 'govuk-licensing-application-forms'
) {

  Govuk::App::Envvar {
    app => $app,
  }
  govuk::app::envvar { "${app}-LANG":
    varname => 'LANG',
    value   => 'en_GB.UTF-8',
  }

  $bucket_name = "${aws_application_form_bucket_name}-${environment}"

  govuk::app::envvar { "${app}-APPLICATION_FORM_BUCKET_NAME":
    varname => 'APPLICATION_FORM_BUCKET_NAME',
    value   => $bucket_name,
  }
  govuk::app::envvar { "${app}-APPLICATION_FORM_AWS_ACCESS_KEY_ID":
    varname => 'APPLICATION_FORM_AWS_ACCESS_KEY_ID',
    value   => $aws_application_form_access_key,
  }
  govuk::app::envvar { "${app}-APPLICATION_FORM_AWS_SECRET_KEY":
    varname => 'APPLICATION_FORM_AWS_SECRET_KEY',
    value   => $aws_application_form_secret_key,
  }
}
