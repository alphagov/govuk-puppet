# Creates the jamesmead user
class users::jamesmead {
  govuk_user { 'jamesmead':
    fullname => 'James Mead',
    email    => 'james.mead@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJXhBL4fySxImt3eVqEFaCuJTNu8V8+FqkOBvY3GQggj james.mead@digital.cabinet-office.gov.uk',
  }
}
