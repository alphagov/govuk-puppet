# Creates the jameschan user
class users::jameschan {
  govuk_user { 'jameschan':
    fullname => 'James Chan',
    email    => 'james.chan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALe+jK0vcBXrYJNVzvBIyaFdPTJ0UQFIKtXacI2ru7Y james.chan@digital.cabinet-office.gov.uk',
  }
}