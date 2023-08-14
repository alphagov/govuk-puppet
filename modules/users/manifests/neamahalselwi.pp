# Creates the user neamahalselwi
class users::neamahalselwi {
  govuk_user { 'neamahalselwi':
    ensure   => absent,
    fullname => 'Neamah Al Selwi',
    email    => 'neamah.alselwi@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJF4DKX97g/MgaesAf5s5ZAVTg5wHSvpnwd/RkV5qTY/ neamah.alselwi@digital.cabinet-office.gov.uk',
  }
}
