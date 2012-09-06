class puppetdb::config {

  # This caters for Amazon Preview where puppetmaster is a small instance
  # When Amazon is dead, we should just make this 1024
  if $::govuk_provider == 'sky' {
      $java_args = '-Xmx1024m'
  } elsif $::govuk_provider == 'scc' {
      $java_args = '-Xmx1024m'
  } else {
      $java_args = $::govuk_platform ? {
        'production'   => '-Xmx1024m',
        default        => '-Xmx192m',
      }
  }

  file { '/etc/default/puppetdb':
    content => template('puppetdb/etc/default/puppetdb'),
  }
}
