# Creates the jonkirwan user
class users::jonkirwan{
  govuk_user { 'jonkirwan':
    fullname => 'Jon Kirwan',
    email    => 'jon.kirwan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJqDx2xeMrSQ70t3IgYNEZyUhbJ2z/JnlO9HNxrKeHTu jon.kirwan@digital.cabinet-office.gov.uk',
  }
}
