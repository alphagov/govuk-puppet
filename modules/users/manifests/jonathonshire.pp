# Creates the Jonathon Shire user
class users::jonathonshire {
  govuk_user { 'jonathonshire':
    fullname => 'Jonathon Shire',
    email    => 'jonathon.shire@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYE827UvmYz0AbbGPUFszMcktnB1ZzwuDpg1lkyaYbg jonathon.shire@digital.cabinet-office.gov.uk',
  }
}
