# == Class: mongodb::logging
#
# Configure logging for mongodb
#
class mongodb::logging {
  @filebeat::prospector { 'mongodb-logstream':
    paths  => ['/var/log/upstart/mongodb.log'],
    fields => {'application' => 'mongodb'},
    tags   => ['stdout', 'stderr', 'upstart', 'mongodb'],
  }
}
