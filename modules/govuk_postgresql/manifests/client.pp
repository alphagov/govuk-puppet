# Wrapper for all the things needed for a postgres client
class govuk_postgresql::client {
  include postgresql::client
  include postgresql::lib::devel
}
