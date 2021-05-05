# Create the murilodalri user
class users::murilodalri {
  govuk_user { 'murilodalri':
    fullname => 'Murilo Dal Ri',
    email    => 'murilo.dalri@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpqSyNhtIK2ZQuCVGTQnyEANltFhOGXRYfIJKopmeHA murilo.dalri@digital.cabinet-office.gov.uk',
    ],
  }
}
