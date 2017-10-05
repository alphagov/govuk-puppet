# == Class: Govuk_containers::Puppetdb
#
# A class that installs and configures the puppetdb
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
class govuk_containers::puppetdb (
  $image = 'puppet/puppetdb',
  $ensure = 'present',
  $image_tag = '5.1.0',
  $envvars = [],
) {

  validate_array($envvars)

  file { [
      '/var/lib/govuk_containers/puppetdb',
      '/var/lib/govuk_containers/puppetdb/puppetlabs',
      '/var/lib/govuk_containers/puppetdb/puppetlabs/puppetdb',
  ]:
    ensure  => directory,
    group   => 'docker',
    mode    => '0775',
    require => File['/var/lib/govuk_containers'],
  }

  file{ '/var/lib/govuk_containers/puppetdb/puppetlabs/puppetdb/conf.d' :
    ensure  => directory,
    group   => 'docker',
    mode    => '0770',
    recurse => true,
    source  => 'puppet:///modules/govuk_containers/puppetdb/conf.d',
    require => File['/var/lib/govuk_containers/puppetdb/puppetlabs/puppetdb'],
  }

  file{ '/var/lib/govuk_containers/puppetdb/puppetlabs/puppetdb/logging' :
    ensure  => directory,
    group   => 'docker',
    mode    => '0775',
    recurse => true,
    source  => 'puppet:///modules/govuk_containers/puppetdb/logging',
    require => File['/var/lib/govuk_containers/puppetdb/puppetlabs/puppetdb'],
  }

  file{ '/var/lib/govuk_containers/puppetdb/puppetlabs/puppetdb/bootstrap.cfg' :
    ensure  => present,
    group   => 'docker',
    mode    => '0644',
    source  => 'puppet:///modules/govuk_containers/puppetdb/bootstrap.cfg',
    require => File['/var/lib/govuk_containers/puppetdb/puppetlabs/puppetdb'],
  }

  ::docker::run { 'puppetdb':
    ensure   => $ensure,
    image    => "${image}:${image_tag}",
    net      => 'docker_gwbridge',
    hostname => 'puppetdb',
    env      => $envvars,
    volumes  => [
      '/var/lib/govuk_containers/puppetdb/puppetlabs:/etc/puppetlabs',
    ],
    ports    => ['8080:8080','8081:8081'],
    require  => [
      Class['govuk_docker'],
        File['/var/lib/govuk_containers/puppetdb'],
    ],
  }

  @@icinga::check { "check_docker_puppetdb_running_${::hostname}":
    check_command       => 'check_nrpe!check_app_up!8080 /pdb/meta/v1/version/latest',
    service_description => 'puppetdb running',
    host_name           => $::fqdn,
  }
}
