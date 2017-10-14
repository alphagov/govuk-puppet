# == Define: Govuk_containers::Envvar
#
# Takes a hash in the form of:
# { 'key': value }
#
# This will convert to the Docker environment variable style:
# KEY=value
#
# It will place these into a single file which can be read in through deployment.
#
define govuk_containers::envvar (
  $directory,
  $ensure = 'present',
  $envvars = {},
) {
  validate_hash($envvars)

  file { "${directory}/${title}.env":
    ensure  => $ensure,
    content => template('govuk_containers/envvar.erb'),
  }
}
