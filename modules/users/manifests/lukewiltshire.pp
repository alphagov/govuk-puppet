# Creates the lukewiltshire user
class users::lukewiltshire {
  govuk_user { 'lukewiltshire':
    fullname => 'Luke Wiltshire',
    email    => 'luke.wiltshire@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWJU1ku2E3LkeMTgKURjMBiv4MyvS+9Lg99vHIk+MPE luke.wiltshire@digital.cabinet-office.gov.uk'
  }
}
