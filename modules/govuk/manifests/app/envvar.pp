# govuk::app::envvar
#
# Defines an app-specific environment variable to be exported when the app is
# run using govuk_spinup or govuk_setenv.
#
# Unlike govuk::envvar, the dependency between the govuk::app::envvar and the
# application is explicitly encoded, so changing a govuk::app::envvar should
# automatically restart the relevant application.

define govuk::app::envvar (
  # Name of the application with which this env var is associated
  $app,
  # Value of the environment variable
  $value,
  $envdir  = "/etc/govuk/${app}/env.d",
  $varname = $title,
  $notify  = true
) {

  if $notify {
    file { "${envdir}/${varname}":
      content => $value,
      notify  => Govuk::App::Service[$app],
    }
  } else {
    file { "${envdir}/${varname}":
      content => $value,
    }
  }
}
