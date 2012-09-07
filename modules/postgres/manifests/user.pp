define postgres::user(
  $ensure = 'present',
  $username = $title,
  $password = ''
) {

  case $ensure {
    'present': {
      postgres::exec { "Create postgres user ${title}":
        command => "psql -c \"create role ${username} with login encrypted password '${password}'\"",
        unless  => "psql -Atc \"select count(*) from pg_user where usename = '${username}'\" | grep -qF 1",
      }
    }
    'absent': {
      postgres::exec { "Remove postgres user ${title}":
        command => "psql -c \"drop role ${username}\"",
        unless  => "psql -Atc \"select count(*) from pg_user where usename = '${username}'\" | grep -qF 0",
      }
    }
    default: {
      fail("Invalid 'ensure' value '${ensure}' for postgres::user")
    }
  }

}
