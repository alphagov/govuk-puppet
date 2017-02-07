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
# [*filebeat_outputs*]
#   Configure what outputs to use when sending the data collected by the beat
#
#   Default: Logstash on localhost
#
class govuk_beat (
  $filebeat_outputs = { logstash => { enabled => true, hosts => ['127.0.0.1:5566'], }, },
){

  class { '::govuk_beat::repo': }

  # Configure Filebeat. The outputs parameter needs a default value for
  # the process to start
  class { '::filebeat' :
    outputs => $filebeat_outputs,
    require => Class['govuk_beat::repo'],
  }

}
