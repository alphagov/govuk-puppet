class puppetdb {
  class {'puppetdb::package': }
  class {'puppetdb::config': }
  class {'puppetdb::service': }
  Class['puppetdb::package'] ~> Class['puppetdb::service']
}
