# Creates danielmountford user
class users::danielmountford {
  govuk_user { 'danielmountford':
    fullname => 'Daniel Mountford',
    email    => 'daniel.mountford@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJdYJWGQZtTexTom86C8v8VM6MxihJUJ7u8OzZlhPAb daniel.mountford@digital.cabinet-office.gov.uk',
  }
}
