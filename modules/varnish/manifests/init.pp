class varnish (
    $default_ttl  = 900,
    $storage_size = '6G'
) {
  case $::lsbdistcodename {
    # in Varnish3, the purge function became ban
    'lucid': {
        $varnish_version = 2
    }
    'precise': {
        $varnish_version = 3
    }
    default: {
        $varnish_version = 2
    }
  }
  include varnish::install
  include varnish::service
}
