class nodejs {
  case $::lsbdistcodename {
    'precise': {
      $version = '0.6.12~dfsg1-1ubuntu1'
    }
    default: {
      $version = '0.8.2'
    }

  package { 'nodejs':
    ensure  => $version,
  }
}
