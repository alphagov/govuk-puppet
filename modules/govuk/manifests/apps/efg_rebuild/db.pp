# == Class: Govuk::Apps::Efg_rebuild::Db
#
# Create the EFG rebuild application database
#
# === Parameters
#
# [*mysql_password*]
#   The MySQL password for the 'efg_rebuild_production' database
#
class govuk::apps::efg_rebuild::db (
  $mysql_password = '',
){

  mysql_user { 'efg_rebuild@%':
    ensure        => 'present',
    password_hash => mysql_password($mysql_password),
  }

  mysql_grant { 'efg_rebuild@%/efg_production.*':
    user       => 'efg_rebuild@%',
    table      => 'efg_rebuild.*',
    privileges => 'ALL',
  }

  mysql_grant { 'efg_rebuild@%/efg_il0.*':
    user       => 'efg_rebuild@%',
    table      => 'efg_il0.*',
    privileges => 'ALL',
  }

}
