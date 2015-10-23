# == Class: hosts::development
#
# Host entries to setup on the development virtual machine.
#
# === Parameters
#
# [*apps*]
#   An array of apps to set up host entries for on the dev VM.
#
# [*services*]
#   An array of hosts to set up on the development VM as services.
#
class hosts::development (
  $apps = [],
  $services = [],
) {
  validate_array($apps, $services)

  $app_domain = hiera('app_domain')
  $default_host_properties = {
    ip => '127.0.0.1',
  }

  $app_hostnames = regsubst($apps, '$', ".${app_domain}")
  ensure_resource('host', $app_hostnames, $default_host_properties)

  $service_hostnames = regsubst($services, '$', '.cluster')
  ensure_resource('host', $service_hostnames, $default_host_properties)
}
