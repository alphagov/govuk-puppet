# == Class: filebeat
#
# Based on https://github.com/pcfens/puppet-filebeat
#
# == Parameters
#
# [*package_ensure*]
#   The ensure parameter for the filebeat package 
#   Default: present
#
# [*service_ensure*]
#   The ensure parameter on the filebeat service
#   Default: running
#
# [*service_enable*]
#   The enable parameter on the filebeat service
#   Default: true
#
# [*purge_conf_dir*]
#   Should files in the prospector configuration directory not managed by puppet be automatically purged
#   Default: true
#
# [*outputs*]
#   (Hash) Will be converted to YAML for the required outputs section of the configuration 
#
# [*prospectors*]
#   (Hash) Prospectors that will be created
#
class filebeat (
  $package_ensure       = present,
  $service_ensure       = running,
  $service_enable       = true,
  $purge_conf_dir       = true,
  $outputs              = {},
  $prospectors          = {},
) {

  anchor { 'filebeat::begin': } ->
  class { '::filebeat::install': } ->
  class { '::filebeat::config': } ->
  class { '::filebeat::service': } ->
  anchor { 'filebeat::end': }

  $prospectors_final = hiera_hash('filebeat::prospectors', $prospectors)

  if !empty($prospectors_final) {
    create_resources('filebeat::prospector', $prospectors_final)
  }

}
