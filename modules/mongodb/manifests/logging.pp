# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb::logging {
  govuk::logstream { 'mongodb-logstream':
    logfile => '/var/log/upstart/mongodb.log',
    fields  => {'application' => 'mongodb'},
    tags    => ['stdout', 'stderr', 'upstart', 'mongodb'],
  }
}
