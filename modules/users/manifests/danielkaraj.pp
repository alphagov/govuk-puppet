# Creates the danielkaraj user
class users::danielkaraj {
  govuk_user { 'danielkaraj':
    fullname => 'Daniel Karaj',
    email    => 'daniel.karaj@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKPJdBt6Qf3HXJn3ki2x3AjQ59gHnEVDC148W3THGtV daniel.karaj@digital.cabinet-office.gov.uk',
  }
}
