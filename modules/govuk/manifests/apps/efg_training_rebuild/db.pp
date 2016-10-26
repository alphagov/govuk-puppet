# == Class: Govuk::Apps::Efg_training_rebuild::Db
#
# Create the EFG Training rebuild application database
#
# === Parameters
#
# [*mysql_password*]
#   The MySQL password for the 'efg_training' database
#
class govuk::apps::efg_training_rebuild::db (
  $mysql_password = '',
){

  mysql_user { 'efg_training_rebuild@%':
    ensure        => 'present',
    password_hash => mysql_password($mysql_password),
  }

  mysql_grant { 'efg_training_rebuild@%/efg_training_production.*':
    user       => 'efg_training_rebuild@%',
    table      => 'efg_training_production.*',
    privileges => 'ALL',
  }

  mysql_grant { 'efg_training_rebuild@%/efg_training_il0.*':
    user       => 'efg_training_rebuild@%',
    table      => 'efg_training_il0.*',
    privileges => 'ALL',
  }

}
