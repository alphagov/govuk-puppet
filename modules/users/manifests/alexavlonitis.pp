# Creates the alexavlonitis user
class users::alexavlonitis {
  govuk_user { 'alexavlonitis':
    fullname => 'Alex Avlonitis',
    email    => 'alex.avlonitis@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB2zpyItMBY+80pmRzvXyn52ZfBbIZzExWbIIfVbqVW5 alex.avlonitis@digital.cabinet-office.gov.uk',
  }
}
