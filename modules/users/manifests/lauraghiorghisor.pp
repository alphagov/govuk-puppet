# Creates the lauraghiorghisor user
class users::lauraghiorghisor {
  govuk_user { 'lauraghiorghisor':
    fullname => 'Laura Ghiorghisor',
    email    => 'laura.ghiorghisor@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsI1RBasfDZD1QxGVl21dYv9a7s1IuXY9hGdnq5bAWU laura.ghiorghisor@digital.cabinet-office.gov.uk',
  }
}
