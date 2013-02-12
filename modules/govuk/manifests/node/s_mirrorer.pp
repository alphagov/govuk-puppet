class govuk::node::s_mirrorer inherits govuk::node::s_base {
  include mirror
  govuk::user { 'govuk-netstorage':
    fullname => 'Netstorage Upload User',
    email    => 'webops@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAw/ksvUhzrUVVbupDXEwz4J2K8Yz515pxhRLpfx6oGruM/hj4wVJ5uPt+4IL5k0sLXxRH0X/VXuK2zBV2fSnPP4cNUZiFrPbN1gea945dGvGIstLMZfsw8Md3jN4i8UXZFBriUfjQT7APLGEsQ+fl+Lzuhpp1nq2oWKem28moAxQkxU2ShPQhP/kzRkTrNbiusOFE4YQN4seZRJEtZ22p+qSVAPVyc2mfJHr6gdVNO3dMBdD7Ud9m3L5AeD7GNA/r2DiJViIplipRMvJJ0w3KkCnTWHiw3C0tXjyAMIH3jXqIJVqUej7Jum3FzixQrFgBR88XkPzlR0qHvR73HBSeZQ==',
  }
  file { '/home/govuk-netstorage/.ssh':
    ensure  => directory,
    owner   => 'govuk-netstorage',
    mode    => '0700',
    require => Govuk::User['govuk-netstorage'],
  }
  file {'/home/govuk-netstorage/.ssh/id_rsa':
    ensure  => file,
    owner   => 'govuk-netstorage',
    mode    => '0600',
    content => extlookup('govuk-netstorage_key_private', ''),
  }
}
