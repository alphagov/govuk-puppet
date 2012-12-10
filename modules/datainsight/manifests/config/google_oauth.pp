class datainsight::config::google_oauth {
  $google_client_id = extlookup('google_client_id_datainsight')
  $google_client_secret = extlookup('google_client_secret_datainsight')
  $google_analytics_refresh_token = extlookup('google_analytics_refresh_token_datainsight')
  $google_drive_refresh_token = extlookup('google_drive_refresh_token_datainsight')

  file { "/etc/gds/google_credentials.yml":
    ensure  => present,
    content => template("datainsight/google_credentials.yml.erb"),
    owner   => "deploy",
    require => User['deploy']
  }

  file { "/var/lib/gds/google-analytics-token.yml":
    ensure  => present,
    content => template("datainsight/google-analytics-token.yml.erb"),
    owner   => "deploy",
    require => User['deploy']
  }

  file { "/var/lib/gds/google-drive-token.yml":
    ensure  => present,
    content => template("datainsight/google-drive-token.yml.erb"),
    owner   => "deploy",
    require => User['deploy']
  }
}