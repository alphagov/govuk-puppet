class puppetdb::config {
  $java_args = $::govuk_provider ? {
    'sky'   => '-Xmx1024m',
    default => '-Xmx192m',
  }

  file { '/etc/default/puppetdb':
    content => template('puppetdb/etc/default/puppetdb'),
  }
}
