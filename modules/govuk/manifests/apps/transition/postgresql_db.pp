# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::transition::postgresql_db ( $password = '' ){
  govuk_postgresql::db { 'transition_production':
    user                    => 'transition',
    password                => $password,
    extensions              => ['plpgsql', 'pgcrypto'],
    allow_auth_from_backend => true,
  }
}
