# Creates the robinwhittleton user
class users::robinwhittleton {
  govuk_user { 'robinwhittleton':
    fullname => 'Robin Whittleton',
    email    => 'robin.whittleton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa REPLACE ME',
  }
}
