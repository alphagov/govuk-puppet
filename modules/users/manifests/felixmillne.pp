# Creates the felixmillne user
class users::felixmillne {
  govuk_user { 'felixmillne':
    fullname => 'Felix Millne',
    email    => 'felix.millne@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOC/gSSz2T7bzsb6f+U/78hschEUvhrD3raZzoiWdlKm felix.millne@digital.cabinet-office.gov.uk',
  }
}
