class graphite {
  class { 'nginx' : node_type => graphite }
  include graphite::package
  include graphite::config
}