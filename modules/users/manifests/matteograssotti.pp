# Creates the matteograssotti user
class users::matteograssotti {
  govuk_user { 'matteograssotti':
    fullname => 'Matteo Grassotti',
    email    => 'matteo.grassotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDoFNcHgk5R6Tv5d5pQNP0+0NNM/8S/l31LpprpY9PHgP5jn1MGuGJy3khdBbLa8YqNJGhBSzoDAueHJjPhjAoEAQZeq7uXQePxEHu7tPlOHIjT3XFkgRxk+nBB4dmAW4EITxZ6rSGgx/eK2QjeXtIpIHxo0FAF1wBLw+DigVZoGBMOeeh0/G67D2qVBmXhg0NwpQSGOf7AgEoim0atLHZ70Q9XAkOJPJ4B0OMyRjCshOzYwG9mhVpIGm5lWe2mQ78m+j72QkXEYiwOUcPJR799XzVPX9tYq/Td7HgCU7AYp4OFjbC3SOI2F2gZ3kefb5CTs3YgShlUV3cKhmWLw8RXkvRZOKTRgqM4Bc8QRgUakwpXIlI2SQXg29xumcLCcen9kzIQMUA2lWcREyIdc+hdEcy3NiFE84ze+olsYqAknNP5/eGDlZUMITRGy8cFbJwVgtYb9bkodAn1D8tEBW/Fdw5CbwIx8vMJCxEKo3Q6JqqXe33DQb7BcX29PQ8bzxp+eiSrhKIyG+jWQ63M/AucOK3zhy125tx3KJu8cyqFimnac/aynXqQB6G5k43ukuXyzRDPocXIwHLGBVMqfFLKB7KeoaLTGQTWuKI+cvPaWVkzfj5os1amrkpVj/nIkPlcr5q0VunY9hft+Lk/L06hL/EIEkBEkIyCnxj3rhfNxQ== mackeyfordev_remote',
  }
}
