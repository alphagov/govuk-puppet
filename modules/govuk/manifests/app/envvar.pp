define govuk::app::envvar (
  # Name of the application with which this env var is associated
  $app,
  # Value of the environment variable
  $value,
  $envdir = "/etc/govuk/${app}/env.d",
  $varname = $title
) {

  file { "${envdir}/${varname}":
    content => $value,
    require => File[$envdir],
    notify  => Govuk::App::Service[$app],
  }

}
