# Create the kelvingan user
class users::kelvingan {
  govuk_user { 'kelvingan':
    fullname => 'Kelvin Gan',
    email    => 'kelvin.gan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1v8UTV0pOjSjZXnvQaWH/m5sOluCQGxeLU8NAbMa20lcazUDhEnQqjQ8SFvfMC06Zu8LWRMMPj3bIdS9I9G7ETWIq4Q8NdHEuOpgBJTcKsiL76hBVyQGWD682xfl4WhAHygsyN6qRGJg8YvkC5sAhYd7nu/9sfI8erc1S7mFt2zzT/4N4ULlI2vHgWGhePPJOfRz7cGi1nxe/WzlYNURVfR0YQfYsxI4vRwjSM0xDelTwKDbb5D1PgcTYx3c2bnrMcQ4FSA7iAyvJJnLSRCcxaCF8XjokR8gBg7Dp9tims0Amjee4J/S1v4ty3Pi8Hm590ZrmuvyVC8KEajCmUnD4JvUAPM7hZYKtLbUsHtR5rF43Ot9gadGV1FF8xEmcMvI0NuqiSuTRV/GPjHxPh+5U5uxrNqODUeTiLHH6m2+Cb55ud5aJJGkbg6nCM2LsWuTN3vbaIwlCxheEdZtp0HLi1XSo6WRiUPKuUpO4a/EX8h9zP+Nd1yeT/9xcyMMFAeieufV3PUjr/7TtG4KpgqzL0C9blWLaYUu9fa7/xT9jJg3yJIFvtidEXtiYvf56tfIr6wWxPkNNYIS5SEarCwI6AoMgMG0geicgzwmPBczovX62IN3lUDskLT0LGo8eliadEeaYCnQ1E3NS2rYwluTdPDYpqIYPH1Vb6MwGajmQBw== kelvin.gan@digital.cabinet-office.gov.uk',
  }
}
