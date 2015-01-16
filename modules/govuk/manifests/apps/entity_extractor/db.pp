# == Class: govuk::apps::entity_extractor::db
#
# Database used by the entity extractor service.
# Read more: https://github.com/alphagov/entity-extractor
#
# === Parameters
#
# [*password*]
#   Database password
#
class govuk::apps::entity_extractor::db (
  $password,
) {
  govuk_postgresql::db { 'entity-extractor_production':
    user                    => 'entity-extractor',
    password                => $password,
    allow_auth_from_backend => true,
  }
}
