# == Class: govuk::apps::stagecraft::postgresql_db

class govuk::apps::stagecraft::postgresql_db(
  $password,
){
  govuk_postgresql::db { 'stagecraft_production':
    user                => 'stagecraft',
    password            => $password,
    allow_auth_from_api => true,
  }
}
