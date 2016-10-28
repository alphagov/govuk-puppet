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

  $username = 'efg_training_re@%'

  mysql_user { $username:
    ensure        => 'present',
    password_hash => mysql_password($mysql_password),
  }

  mysql_grant { "${username}/efg_training_production.*":
    user       => $username,
    table      => 'efg_training_production.*',
    privileges => 'ALL',
  }

  mysql_grant { "${username}/efg_training_il0.*":
    user       => $username,
    table      => 'efg_training_il0.*',
    privileges => 'ALL',
  }

}
