class puppetdb {
  class {'puppetdb::package': }
  class {'puppetdb::service': }
  Class['puppetdb::package'] ~> Class['puppetdb::service']
}
