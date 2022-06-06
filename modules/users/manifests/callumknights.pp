# Creates the callumknights user
class users::callumknights {
  govuk_user { 'callumknights':
    fullname => 'Callum Knights',
    email    => 'callum.knights@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPD14Uaufg4rEDkEfvRe7jthXa7deMPEqtz8oNQKxrP callum.knights@digital.cabinet-office.gov.uk',
  }
}
