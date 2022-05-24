# Creates the peterhattyar user
class users::peterhattyar {
  govuk_user { 'peterhattyar':
    fullname => 'Peter Hattyar',
    email    => 'peter.hattyar@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPpr8FiWlxLaqRqCXpyI28tZrcpWKZzk2CnnzzhlzZ3L peter.hattyar@digital.cabinet-office.gov.uk',
  }
}