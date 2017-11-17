# == Class: Govuk_containers::Puppetserver
#
# A class that installs and configures the puppetserver
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
class govuk_containers::puppetserver (
  $image = 'puppet/puppetserver',
  $ensure = 'present',
  $image_tag = '5.1.0',
  $envvars = [],
) {

  validate_array($envvars)

  file { [
      '/var/lib/govuk_containers/puppetserver',
      '/var/lib/govuk_containers/puppetserver/puppetlabs',
      '/var/lib/govuk_containers/puppetserver/puppetlabs/puppetserver',
      '/var/lib/govuk_containers/puppetserver/puppetlabs/puppet',
  ]:
    ensure  => directory,
    group   => 'docker',
    require => File['/var/lib/govuk_containers'],
  }

  file { '/var/lib/govuk_containers/puppetserver/puppetlabs/puppet/ssl':
    ensure  => directory,
    group   => 'docker',
    mode    => '0775',
    require => File['/var/lib/govuk_containers'],
  }

  file { '/var/lib/govuk_containers/puppetserver/puppetlabs/puppetserver/conf.d':
    ensure  => directory,
    group   => 'docker',
    recurse => true,
    source  => 'puppet:///modules/govuk_containers/puppetserver/conf.d',
    require => File['/var/lib/govuk_containers/puppetserver/puppetlabs/puppetserver'],
  }

  file { '/var/lib/govuk_containers/puppetserver/puppetlabs/puppet/puppet.conf':
    ensure  => present,
    group   => 'docker',
    mode    => '0644',
    content => template('govuk_containers/puppet/puppet.conf.erb'),
    require => File['/var/lib/govuk_containers/puppetserver/puppetlabs/puppet'],
  }

  file { '/var/lib/govuk_containers/puppetserver/puppetlabs/puppet/certsigner.rb':
    ensure  => present,
    group   => 'docker',
    mode    => '0755',
    source  => 'puppet:///modules/govuk_containers/puppet/certsigner.rb',
    require => File['/var/lib/govuk_containers/puppetserver/puppetlabs/puppet'],
  }

  file { '/var/lib/govuk_containers/puppetserver/puppetlabs/puppet/puppetdb.conf':
    ensure  => present,
    group   => 'docker',
    source  => 'puppet:///modules/govuk_containers/puppet/puppetdb.conf',
    require => File['/var/lib/govuk_containers/puppetserver/puppetlabs/puppet'],
  }

  ::docker::run { 'puppet':
    ensure   => $ensure,
    image    => "${image}:${image_tag}",
    net      => 'docker_gwbridge',
    hostname => 'puppet',
    env      => $envvars,
    volumes  => [
      '/var/lib/govuk_containers/puppetserver/puppetlabs/puppetserver/conf.d:/etc/puppetlabs/puppetserver/conf.d',
      '/var/lib/govuk_containers/puppetserver/puppetlabs/puppet:/etc/puppetlabs/puppet',
      '/usr/share/puppet/production/current:/etc/puppetlabs/code:ro',
    ],
    ports    => ['8140:8140'],
    require  => [
      Class['govuk_docker'],
      File['/var/lib/govuk_containers/puppetserver/puppetlabs/puppetserver/conf.d'],
      File['/var/lib/govuk_containers/puppetserver/puppetlabs/puppet'],
    ],
  }
}
