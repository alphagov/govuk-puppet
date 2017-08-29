# == Class: govuk_postgresql::server::not_slave
#
# Collect virtual resources that should exist on `server::standalone` and
# `server::primary` nodes but NOT `server::standby`.
#
class govuk_postgresql::server::not_slave {
  Postgresql::Server::Role           <| tag == $name |>
  Govuk_postgresql::Rds_sql          <| tag == $name |>
  Postgresql::Server::Db             <| tag == $name |>
  Postgresql::Server::Database_grant <| tag == $name |>
  Govuk_postgresql::Extension        <| tag == $name |>
}
