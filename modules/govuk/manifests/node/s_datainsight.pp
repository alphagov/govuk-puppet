class govuk::node::s_datainsight inherits govuk::node::s_base {

  include nginx
  include govuk::node::s_ruby_app_server

  include rabbitmq

  include datainsight::recorders::weekly_reach
  include datainsight::recorders::todays_activity
  include datainsight::recorders::format_success
  include datainsight::recorders::insidegov
  include datainsight::recorders::everything

  datainsight::collector { 'ga': }
  datainsight::collector { 'insidegov': }
  datainsight::collector { 'nongovuk-reach': }

  # FIXME: Purge files from production
  # Remove once Puppet has been deployed to production
  file { '/etc/govuk/backdrop-ga-collector/google_client_secret.json':
    ensure => absent,
  }
  file { '/var/lib/govuk/backdrop-ga-collector':
    ensure => absent,
  }
  file { '/var/lib/govuk/backdrop-ga-collector/google_storage.db':
    ensure => absent,
  }

}
