class datainsight::config::mysql {
  class { 'govuk_mysql::server':
    root_password => extlookup('mysql_datainsight', '')
  }

  include govuk_mysql::libdev
  include mysql::client
}
