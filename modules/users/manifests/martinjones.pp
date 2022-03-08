# Creates the martinjones user
class users::martinjones {
  govuk_user { 'martinjones':
    fullname => 'Martin Jones',
    email    => 'martin.jones@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuZsUnbaKyJyqbcUFr4Io0BI7nkwLTYEJimV2/GgroD martin.jones@digital.cabinet-office.gov.uk',
  }
}
