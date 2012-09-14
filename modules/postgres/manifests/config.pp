class postgres::config {

  File {
    owner  => 'postgres',
    group  => 'postgres',
  }

  file { '/etc/postgresql/9.1/main/postgresql.conf':
    ensure => present,
    source => 'puppet:///modules/postgres/postgresql.conf',
  }

  file { '/etc/postgresql/9.1/main/pg_hba.conf':
    ensure => present,
    source => 'puppet:///modules/postgres/pg_hba.conf',
  }

  # pg_ident.conf supplies mappings between system users and postgres users.
  # We have no need for this, so ensure the file is empty.
  file { '/etc/postgresql/9.1/main/pg_ident.conf':
    ensure  => present,
    content => '',
  }

}
