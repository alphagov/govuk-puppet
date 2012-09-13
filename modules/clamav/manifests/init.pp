class clamav {
  package { 'clamav':
    ensure => '0.97.5',
  }

  # I'm adding this class as we'll probably add some clamav utils / services in here also
  # but at the moment it simply installs the clamav package, which does most of the work

  # Also TODO:
  # Add something in here to allow for modification of the default clamav config in /opt/clamav/etc
}
