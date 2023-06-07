# == Class: Govuk_Node::S_db_admin
#
# This machine class is used to administer RDS instances.
#
class govuk::node::s_db_admin(
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  include ::govuk::node::s_base
  include govuk_env_sync

  ### MongoDB ###

  apt::source { 'mongodb41':
    ensure       => 'absent',
    location     => "http://${apt_mirror_hostname}/mongodb4.1",
    release      => 'trusty-mongodb-org-4.1',
    architecture => $::architecture,
    repos        => 'multiverse',
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  apt::source { 'mongodb36':
    location     => "http://${apt_mirror_hostname}/mongodb3.6",
    release      => 'trusty-mongodb-org-3.6',
    architecture => $::architecture,
    repos        => 'multiverse',
    key          => $apt_mirror_gpg_key_fingerprint,
  }

  package { 'mongodb-org-shell':
    ensure  => latest,
  }

  package { 'mongodb-org-tools':
    ensure  => latest,
  }

  $alert_hostname = 'alert'

  ## Temporarily re-add PostgreSQL tooling to allow ETL between
  ## Mongo and RDS PostgreSQL content-stores
  # include the common config/tooling required for our DB admin class
  class { '::govuk::nodes::postgresql_db_admin':
    postgres_host       => $postgres_host,
    postgres_user       => $postgres_user,
    postgres_password   => $postgres_password,
    postgres_port       => $postgres_port,
    apt_mirror_hostname => $apt_mirror_hostname,
  }

  -> class { '::govuk::apps::draft_content_store_on_postgresql_db_admin::db': }
}
