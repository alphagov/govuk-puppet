# Creates the samsimpson user
class users::samsimpson {
  govuk_user { 'samsimpson':
    fullname => 'Sam Simpson',
    email    => 'sam.simpson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGtiWG65GGmpzqG48BWeB6TXTx8hdR26uu2MyG+JCMa sam.simpson@digital.cabinet.office.gov.uk',
  }
}
