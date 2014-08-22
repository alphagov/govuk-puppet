# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::efg::db (
  $mysql_efg = '',
  $mysql_efg_il0 = ''
){

  mysql::db { 'efg_production':
    user     => 'efg',
    host     => '%',
    password => $mysql_efg,
  }

  # Previously in 9c8eff3 we were creating two mysql::db with the same user (efg@%) but two different passwords.
  # what actually happened is we got two databases and one user. The second password was ignored, because
  # before creating it we would check for the user's existence and assume it already existed.
  # This replicates that behaviour (there is no second password) but the efg user can access both databases
  mysql_database { 'efg_il0':
    charset => 'utf8',
    collate => 'utf8_general_ci',
  }
  mysql_grant { 'efg@%/efg_il0.*':
      user       => 'efg@%',
      table      => 'efg_il0.*',
      privileges => 'ALL',
  }

}
