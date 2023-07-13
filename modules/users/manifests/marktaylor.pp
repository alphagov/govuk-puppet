# Creates the marktaylor user
class users::marktaylor {
  govuk_user { 'marktaylor':
    fullname => 'Mark Taylor',
    email    => 'mark.taylor1@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILR/MrdEQnFLK0rhQNEF9bHT5YTFvtK3E0zTuaAShwR6 mark.taylor1@digital.cabinet-office.gov.uk',
  }
}
