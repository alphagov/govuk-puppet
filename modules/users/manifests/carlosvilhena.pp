# Creates the carlosvilhena user
class users::carlosvilhena {
  govuk_user { 'carlosvilhena':
    fullname => 'Carlos Vilhena',
    email    => 'carlos.vilhena@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5ezY3HSYCV+CQQaOtiu1lNyPaciUm8vL1Z/a5YVBnK9dhlo8ZNEZCEvyyXy82OdtFXSawthhh/uuDJlM0SUaSeJcvR++gKJl25uDT6QJay7R46BIAb0qDgKd07Y76HSK7sf1LwkfBh+32RciMIwcKq5pu6HoA8R09+9690qfRRDSV/vt36qzzEvzjI7mbb2FOPlUtaUiqwewcQnmi2Op9sUPyv4YGx6Cw5PeXiNQxt2xNiYg/S34/vyTumPEqAn3a9iRRgxbv59gZq+ems7Cd7wXeDE4U8QOc3bGAYpH+uKCZHDEu+DC5U8wtEVIwHqqpgMZ8Sxk+F/tt20gTypIbV9Q6GaxwpF3mClO0XcZQrOlkJ4VarcHutz47isuNLYkSqRAcdFtOKTWTErikknc4VbyEnJlx2zLLFCko/CJaL78XMFy44DbX9ostxGezuqW71zoOoCMmV8UMKlUXqAA7GWuG7syOTj0rv4jJgWhXBOwpn/KyuwKLODBtdJNaxDYIoYSDIm4Lmh/3vdwL/QFZ1/sC9jz88B1Yfclgnaf+qUV+wLjEMZV5WEl/UJaK4N94GsX0mrgVv6iYDrGVUzvcUsZ4YgOWEp/NgVwjaj61O/LCsXWQDRDesv8ICeeERAQyYuXQu6bg2L4TfACp0UyxItpJc6aHYE/yxz1PT3yvHQ== carlos.vilhena@digital.cabinet-office.gov.uk',
  }
}
