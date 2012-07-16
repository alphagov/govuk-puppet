class mongodb::server (
  replicaset = $govuk_platform) {
  include mongodb::repository
  include mongodb::package
  class {'mongodb::configuration': replicaset => $replicaset}
  include mongodb::service
  include mongodb::monitoring
}
