# Wrapper for all the things needed for a postgres backup
class govuk_postgresql::backup {
  include backup::client
}
