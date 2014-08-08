class govuk::apps::url_arbiter::db (
  $password,
) {

  govuk_postgresql::db { 'url-arbiter_production':
    user       => 'url-arbiter',
    password   => $password,
  }
}
