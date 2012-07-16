class elasticsearch($cluster) {
  include elasticsearch::package
  class {'elasticsearch::config':
    cluster => $cluster
  }
  include elasticsearch::service
  include elasticsearch::monitoring
}
