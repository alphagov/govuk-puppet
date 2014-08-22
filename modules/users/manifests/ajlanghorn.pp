# Creates the ajlanghorn user
class users::ajlanghorn {
  govuk::user { 'ajlanghorn':
    fullname => 'Andrew Langhorn',
    email    => 'andrew.langhorn@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNRVe5iVIwcWJ4vxv4e1EgxuXelMYMbYop0TnzHmI2Kj/olA7x0eZy2nXIMQovjteGEu14exuDnWxXsZZA0yIcNKQKgX+WIcqsZX1hnzfVtX6+asLsolVn6OE+WalY3tYD6h2O94BYzYDnazARebdDC9tlAPxPFZG+TJYmgdHn/atzr9A5iEjFyprMYvf8JRxg1eP+uB/Zty6oy2jXyKAuPDjNEikkIFrSov2kHYvLSY5k10cI1sTjvU47yp7J/KmXlkAO4wfr0L+ffpRibUf85FnvLq3HG7ruXoYDMEX4NEB7xzE8D2Dn58mOIUuqIQio2YDRah7FByZHxR/85ntT',
  }
}
