# == Class: govuk_beat
#
# Wrapper for the upstream 'filebeat' module.
#
# === Examples
#
# To add a Filebeat prospector, update the Hiera key 'govuk_beat::filebeat_prospectors'. Hiera
# will merge prospector declarations down the Hiera hierarchy
#
# filebeat::prospectors:
#   syslog:
#     paths:
#       - '/var/log/syslog'
#
# === Parameters:
#
# [*hosts*]
#   Configure Logstash hosts to send the data collected by the beat
#
#   Default: localhost
#
class govuk_beat (
  $hosts = ['127.0.0.1:5566'],
){
  validate_array($hosts)

  class { '::govuk_beat::repo': }

  $filebeat_outputs = {
    logstash => {
      enabled => true,
      hosts   => $hosts,
      ssl     => {
        enabled => true,
      },
    },
  }

  # Configure Filebeat. The outputs parameter needs a default value for
  # the process to start
  class { '::filebeat' :
    outputs => $filebeat_outputs,
    require => Class['govuk_beat::repo'],
  }

}
