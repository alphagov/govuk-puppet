# Creates the jonathanyoung user
class users::jonathanyoung {
  govuk_user { 'jonathanyoung':
    ensure   => absent,
    fullname => 'Jonathan Young',
    email    => 'jonathan.young@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcjWkCw8XkoiarGeL0k2CQ8SOxDswIt7nWh1A0GyaFg jonathan.young@digital.cabinet-office.gov.uk',
  }
}
