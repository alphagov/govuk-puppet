# Creates the tuomasnylund user
class users::tuomasnylund {
  govuk_user { 'tuomasnylund':
    fullname => 'Tuomas Nylund',
    email    => 'tuomas.nylund@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM61TGXGjps7QwKoM2Zlu/Y2O9hzzE971yfdP0hckx+R tuomas.nylund@digital.cabinet-office.gov.uk',
  }
}
