class puppetdb::config {
  file { '/etc/default/puppetdb':
    content => template('puppetdb/etc/default/puppetdb'),
  }
}
