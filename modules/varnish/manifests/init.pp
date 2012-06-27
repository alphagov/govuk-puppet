class varnish (
    $default_ttl  = 9000,
    $storage_size = '6G'
) {
  include varnish::install
  include varnish::service
}
