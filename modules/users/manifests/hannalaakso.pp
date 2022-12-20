# Creates the hannalaakso user
class users::hannalaakso {
  govuk_user { 'hannalaakso':
    fullname => 'Hanna Laakso',
    email    => 'hanna.laakso@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAryV2nwcdaUbNjo2NGgHfWclwrJqjbxbUWv278DGk0W hanna.laakso@digital.cabinet-office.gov.uk',
  }
}