# Creates the timblair user
class users::timblair {
  govuk_user { 'timblair':
    fullname => 'Tim Blair',
    email    => 'tim.blair@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEVLBTopejfMwpkvym6y14L8cvAlvsvLrlwKCS20rV6Os68qBAkKgfVSmBT2lZs64BX64nFRG3Lpuj1fil7GA+R6FEmIr21nIDtSSB1GCiANuWhPt1urgf6UVUd9HDoqxziXSvrWy7F5Xz2kIwq6k0MSdrMzJHl5c3ntkNhcxUg0NdgvYM0dmky/pAIx2xFT91zQE0Ak9swkzBQxzb/VjKLAKn9z+s2O6CNCeDu5pDqrFUNUzLZxtSsHIOJv9onFT4PYTslrC4Zvn0O2PDKyYuODnB7DvhpWBeiPs7vwbjARCjSXHi0eOOE789ySd4BJVm/sbz2zKKnpA8PePb4NCwLoVdX65pRlyKb1K5+zvCrdMmXOlaa3nLkSIfedIzwq5uR1u8K+KMq8Du1eSfUTUlgoNJZ1uwHmB5O7SaQ4jfvMPdG1MEoB1Y2Akh3xMrzPblD81Mc9wPhQHyw1h69QyVUZ5HiKFFXLjG8VdIlRcTfdDEvUy71L6TA9/Uw/MuVJWIGgAAkEZQIxdmnhMWTV6zt2tBvHjbOZ4G+1xUB+8KKqlR0iWEAdq7jnPLBCN0dbtzdgvNhzHO+u6vplNqPUgxkwzisfNdWC7c66RA05z+eUo6rX3Ks+yoOCf/1yUARncituuC84hY8IWdGpvpaOsgn70wVkw1UOVQ7mpALEA0TQ== tim.blair@digital.cabinet-office.gov.uk',
  }
}
