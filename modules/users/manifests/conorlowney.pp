# Creates the user conorlowney
class users::conorlowney {
  govuk_user { 'conorlowney':
    fullname => 'Conor Lowney',
    email    => 'conor.lowney@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINTX8PqeNjz8MA4E/kJ5mJBTVqjGd3mKBMknX3jm9pFP conor.lowney@digital.cabinet-office.gov.uk',
  }
}
