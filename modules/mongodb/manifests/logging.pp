# == Class: mongodb::logging
#
# Configure logging for mongodb
#
class mongodb::logging {
  govuk_logging::logstream { 'mongodb-logstream':
    logfile => '/var/log/upstart/mongodb.log',
    fields  => {'application' => 'mongodb'},
    tags    => ['stdout', 'stderr', 'upstart', 'mongodb'],
  }
}
