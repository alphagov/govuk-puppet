# Create the davidking user
class users::davidking {
  govuk_user { 'davidking':
    fullname => 'David King',
    email    => 'david.king@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVAbNvaMMXoKjor0Uv0MLyo6VL/G9j0gH6GDJmYDvGU davidking@gds3622.local',
    ],
  }
}
