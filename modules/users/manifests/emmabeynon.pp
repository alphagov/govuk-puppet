# Creates emmabeynon user
class users::emmabeynon {
  govuk_user { 'emmabeynon':
    ensure   => absent,
    fullname => 'Emma Beynon',
    email    => 'emma.beynon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDW+14V2j2nG/zP2NnpCDigIgy75F7bvijGuOnUM1puh1Vi8ONYVZ5g+hKS+8Nz+ld9wmWG+d2lVVNloDFOG2u0F7Uz9ucyPBm7g7zzArkTc4ll+TRiRMt0MTRFK3wY6SqcVAnQj0mNEHn8bZ6etrMRlFRgf6Tjv8gyC+ctXaF8jmcf96AWWJhd06fLEKovRXnPFFQDrHi+nJ7vvYbNb3zK9gmZ+fi0D6holtOF4rnHJnUbpj0+hCWRbdjYdJJBBXP1FB51w3NpoUObXxyYgNlE/ofVWZxCdmrl6bAYvREeF1flr4vENeZ8e1cExke64LLi5epD5CGYgV93TxFgFU/9/k5R2cnU8dSh1MwU1yGZiRgXrXnGBxUKR2BMfSYK3tIMaFieRgRkLolW3W6GlhJR4rUcdJYEfUfCakydKIwxVAvzkGB/4/8XOVSBjO3ZD7SnyMvd3+6lRGie2Yv2ktOWbgsm4YGoxy3pJInI8zu9gR91/5/Fq1ucfQIZfYlCxMkYgBnId2sQuI9h6kvGKZ4k5cEOcS/8L7KUX7iiVtKOi4gNOYXtVWmZh1Z34UfWGFl/vHCqIWUdFcwxsbqUW9vAkEIV9Qtd0naiTFMteO3+SKCaQrTwq/aG0pN3kNtvf7c+vvkcA+PFozGvsnjn8UTugl7F044BmX+FTHs7pDsKKQ== emma.beynon@digital.cabinet-office.gov.uk',
  }
}
