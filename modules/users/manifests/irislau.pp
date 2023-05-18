# Creates the user irislau
class users::irislau {
  govuk_user { 'irislau':
    fullname => 'Iris Lau',
    email    => 'iris.lau@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgqU5nysfiuDjhu2l90A7hQS5H1mcCNnGKOt1pZkIby iris.lau@digital.cabinet-office.gov.uk',
  }
}
