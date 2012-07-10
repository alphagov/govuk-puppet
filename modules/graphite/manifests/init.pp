class graphite {
  include govuk::repository

  class { 'nginx' : node_type => graphite }
  include graphite::package, graphite::config
}