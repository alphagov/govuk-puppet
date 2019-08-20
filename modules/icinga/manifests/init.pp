# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class icinga {

  contain icinga::package
  contain icinga::config
  contain icinga::service
  include icinga::nginx

  Class['icinga::package']
  -> Class['icinga::config']
  ~> Class['icinga::service']

  Class['icinga::package'] ~> Class['icinga::service']

  Icinga::Host            <<||>> { notify => Class['icinga::service'] }
  Icinga::Check           <<||>> { notify => Class['icinga::service'] }
  Icinga::Check::Graphite <<||>> { notify => Class['icinga::service'] }
  Icinga::Passive_check   <<||>> { notify => Class['icinga::service'] }
}

