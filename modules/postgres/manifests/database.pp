define postgres::database (
  $ensure = 'present',
  $owner = false,
  $template = 'template1',
  $encoding = false
) {

  if ($ensure != 'absent') and $owner {
    Postgres::User[$owner] -> Postgres::Exec["Create postgres database '${title}'"]
  }

  $ownerstring = $owner ? {
    false   => '',
    default => "-O '${owner}'"
  }

  $encodingstring = $encoding ? {
    false   => '',
    default => "-E '${encoding}'",
  }

  case $ensure {
    'present': {
      postgres::exec { "Create postgres database '${title}'":
        command => "createdb ${ownerstring} ${encodingstring} '${title}' -T '${template}'",
        unless  => "psql -Atc \"select count(*) from pg_catalog.pg_database where datname='${title}'\" | grep -qF 1",
      }
    }
    'absent': {
      postgres::exec { "Remove postgres database '${title}'":
        command => "dropdb '${title}'",
        unless  => "psql -Atc \"select count(*) from pg_catalog.pg_database WHERE datname='${title}'\" | grep -qF 0",
      }
    }
    default: {
      fail "Invalid 'ensure' value '${ensure}' for postgresql::database"
    }
  }
}

