# Creates the Oliver Roberts user
class users::oliverroberts {
  govuk_user { 'oliverroberts':
    fullname => 'Oliver Roberts',
    email    => 'oliver.roberts@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJbKL7LVndmZJ5s7s8/2U2yz0P+LVirH0fPnqpFQQU6t ollyroberts@github.com',
  }
}
