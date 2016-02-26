# Creates the matmoore user
class users::matmoore {
  govuk_user { 'matmoore':
    fullname => 'Mat Moore',
    email    => 'mat.moore@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCgVBCjPNhjGkZK2ruZ4YPaHL+bdAA/77+/Al7ulNWZ9ZEg92vXXh7Iaj40n6STW15IF59iSdjbR8JJLgczrlthJA4gKAMOTu+u/ytq+TZsIeQniYWcXE9OYfNwQzHYPof5xIia2z/KWXwaMqqcIsQ/6IhbAzaq+3WCdinHhGFGYq0248P1Qob57xIPoCZ2mqbB3eooB5R3ipmelXFC6uJacQfjzN38wOgHfjRYwvVxAlf60VM7zpsrdkX7Tu26hNs1CCCj7IzujKu9S58AU79hWIUkMNKuqH0Qu9TBnDNanmw0x9g56W97KpyR3pSCJj4H4XrUcZZHISKnfEb+lmnFJc/zuXt3f4mK94/3BRZJuuv3gEsEVTIhM5ge6PKLTnpEpyGLjFbt4H+8+w7bQpyl2luilT93tUq3SDUSw6/lX8N9YbuoQVacnUWRrCej6r5PmVXA/D6OKrDGdTAcFfG7gKAZfUK/PV37XaXFA0muXGaG/rRb7VZAsrCer2c+EYGFH5moYi2jGAg4mfiJQDzVDYU9tG6pu+yklbsZ7OyScQFdaO/Tjsqd+ko8VTlnLWnTq7017C5L4MdmoAjKzRGI2NuYgT/HxAQ661ihfDaoKoKQ3vKZe6/ntJeUNVI8R8Imna3yxadAuYvXvPjeHxI97VX7FVHO+NYkVMtbnd4Y4w== mat.moore@digital.cabinet-office.gov.uk',
  }
}
