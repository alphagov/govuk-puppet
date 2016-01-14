# Creates the jennyduckett user
class users::jennyduckett {
  govuk::user { 'jennyduckett':
    fullname => 'Jenny Duckett',
    email    => 'jenny.duckett@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
