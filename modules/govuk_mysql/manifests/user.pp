# == Define: govuk_mysql::user
#
# A simple wrapper for `mysql_user` and `mysql_grant`. This makes it easier
# to create a MySQL user with a single GRANT but no db (as `mysql::db`), as
# is quite common.
#
# It also serves to guard us against the odd behaviour of `mysql_grant`
# which will create resources, but not idempotently, if the resource title
# doesn't match the `user` and `table` params:
#
# - https://github.com/puppetlabs/puppetlabs-mysql/issues/460
#
# The title of this resource must be in the form of: `user@host`
#
# We have added a conditional for the migration to AWS. We have chosen to use
# RDS to host our MySQL databases, and so we do not want to install and set up
# MySQL server, or include any Puppet relationships to that effect.
#
# === Parameters
#
# [*ensure*]
#   Default: present
#
# See `mysql_user` and `mysql_grant` for the following:
#
# [*password_hash*]
# [*table*]
# [*privileges*]
#
define govuk_mysql::user (
  $password_hash,
  $table,
  $privileges,
  $ensure = present,
) {
  validate_re($name, '^.+@[^/]+$')

  if $::aws_migration {
    mysql_user { $name:
      ensure        => $ensure,
      password_hash => $password_hash,
    }

    if $ensure == 'present' {
      mysql_grant { "${name}/${table}":
        ensure     => $ensure,
        user       => $name,
        table      => $table,
        privileges => $privileges,
      }
    }
  } else {
    mysql_user { $name:
      ensure        => $ensure,
      password_hash => $password_hash,
      require       => Class['govuk_mysql::server'],
    }

    if $ensure == 'present' {
      mysql_grant { "${name}/${table}":
        ensure     => $ensure,
        user       => $name,
        table      => $table,
        privileges => $privileges,
        require    => Class['govuk_mysql::server'],
      }
    }
  }
}
