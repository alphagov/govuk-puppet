# Create the kelvingan user
class users::kelvingan {
  govuk_user { 'kelvingan':
    fullname => 'Kelvin Gan',
    email    => 'kelvin.gan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCUw2VAu3XgWepMdarEvhA/IPdtUme14JhbwBD44qym kelvin.gan@digital.cabinet-office.gov.uk',
  }
}
