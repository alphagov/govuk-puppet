class govuk::apps::backdrop_ga_collector {
  datainsight::collector { 'backdrop-ga-collector':
    vhost => 'backdrop-ga-collector'
  }

  $google_client_id = extlookup('google_client_id_backdrop')
  $google_client_secret = extlookup('google_client_secret_backdrop')
  $google_refresh_token = extlookup('google_analytics_refresh_token_backdrop')

  file { "/etc/govuk/backdrop-ga-collector/google_client_secret.json":
    ensure  => present,
    content => template("govuk/google_client_secrets.json.erb"),
    owner   => "deploy"
  }

  file { "/var/lib/govuk/backdrop-ga-collector/google_storage.db":
    ensure  => present,
    content => template("govuk/google_storage.db.erb"),
    owner   => "deploy"
  }
}