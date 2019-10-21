# Creates the sebastianszypowicz user
class users::tomwhitwell {
  govuk_user { 'tomwhitwell':
    fullname => 'Tom Whitwell',
    email    => 'tom.whitwell@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILb/0/9cf3s7x+LlOC+4xWJ0ogzWUInOeZCBHRqhxqoD tom.whitwell@digital.cabinet-office.gov.uk',
  }
}