# Wrapper for all the things needed for a postgres client
class govuk_postgresql::client {
  include postgresql::client  # installs postgresql-client-common, which includes psql
  include postgresql::lib::devel  # installs libpq-dev package needed for pg gem
}
