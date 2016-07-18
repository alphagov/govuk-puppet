# == Class: mongodb::config
#
# Configures a MongoDB server.
#
# === Parameters:
#
# [*config_filename*]
#   The config file mongo should use. This varies between mongo 2 and 3.
#
# [*dbpath*]
#   Path to database on filesystem
#
# [*development*]
#   Disable journalling and enable query profiling.
#   Saves space at the expense of data integrity.
#   Default: false
#
# [*oplog_size*]
#   Defines size of the oplog in megabytes.
#   If undefined, we use MongoDB's default.
#
# [*replicaset_name*]
#   A string for the name of the replicaset.
#   Passed in by `mongodb::server` which sets it to
#   'production' unless $development is true, in which
#   case it is set to 'development'.
#
# [*template_name*]
#   The name of the template that will be used as the config file.
#
class mongodb::config (
  $config_filename,
  $template_name,
  $dbpath = '/var/lib/mongodb',
  $development,
  $oplog_size = undef,
  $replicaset_name,
) {
  validate_bool($development)


  # Class params are used in the templates below.
    file { $config_filename:
      ensure  => present,
      content => template("mongodb/${template_name}"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

}
