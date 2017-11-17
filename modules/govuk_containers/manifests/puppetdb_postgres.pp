# == Class: Govuk_containers::Puppetdb_postgres
#
# A class that installs and configures the puppetdb-postgres
# container.
#
# === Parameters:
#
# [*image*]
#   The container image to run.
#
# [*ensure*]
#   Whether to ensure the frameworking for the app to exist.
#   Default: present
#
# [*image_tag*]
#   The image tag to run. In our deployment this should not be specified
#   as we will explicitly tag images. However, for local development this
#   parameter can be set.
#
# [*envvars*]
#   An array of environment variables to start the container with.
#
class govuk_containers::puppetdb_postgres (
  $image = 'puppet/puppetdb-postgres',
  $ensure = 'present',
  $image_tag = '9.6.3',
  $envvars = [],
) {

  validate_array($envvars)

  file { ['/var/lib/govuk_containers/puppetdb-postgres', '/var/lib/govuk_containers/puppetdb-postgres/data']:
    ensure  => directory,
    require => File['/var/lib/govuk_containers'],
  }

  ::docker::run { 'puppetdb-postgres':
    ensure   => $ensure,
    image    => "${image}:${image_tag}",
    net      => 'docker_gwbridge',
    hostname => 'puppetdb-postgres',
    env      => $envvars,
    ports    => ['5432:5432'],
    volumes  => [
      '/var/lib/govuk_containers/puppetdb-postgres/data:/var/lib/postgresql/data',
    ],
    require  => [
      Class['govuk_docker'],
      File['/var/lib/govuk_containers/puppetdb-postgres/data'],
    ],
  }
}
