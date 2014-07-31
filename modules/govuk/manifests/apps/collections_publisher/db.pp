class govuk::apps::collections_publisher::db(
  $mysql_password,
) {
  mysql::db {'collections_publisher_production':
    user     => 'collections_pub',
    host     => '%',
    password => $mysql_password,
  }
}
