# Creates the leenagupte user
class users::leenagupte {
  govuk::user { 'leenagupte':
    fullname => 'Leena Gupte',
    email    => 'leena.gupte@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJ/xSWPOq2AqXHrFghnNFgZA673Nq9/e0ma9fD3tTR23/lpkhesqARpR+mOAy6nzv6Ni5Rl/8IIMFLSUmoFeGP15LHtWwtBgFQkzWo0BRVuBF8WFzzbXedR/j4Am3niA/MN1y05tehdeHMkN4KW2FXwyMy2nKLThtE5QPE7sG2mFKZQ5GYbIWPmlLn3uMFmmkZGpErqj8exVgxzah2zka3BVuxjOg9ci7Gvv7r4gquXJ56vm6exyvX/HAjszbYC2FgQkjsouyVfyJp93HDKe4936kVYC+lAbsjF6VVaOdYuVhhq/YescJeinMXuat5abP/wk1g5w4CVjvzeLlebBfx',
  }
}
