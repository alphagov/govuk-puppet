# Creates the alistairdavidson user
class users::alistairdavidson {
  govuk_user { 'alistairdavidson':
    fullname => 'Alistair Davidson',
    email    => 'alistair.davidson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG1kbWXb/GHt31zGfbjxHJQE3Hx/0F/G15VbYc7nkUj alistair.davidson@digital.cabinet-office.gov.uk',
  }
}
