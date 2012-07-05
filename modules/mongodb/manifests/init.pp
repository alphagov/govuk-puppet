class mongodb {
  include mongodb::repository
  include mongodb::package
  include mongodb::configuration
  include mongodb::service
  include mongodb::monitoring
}
