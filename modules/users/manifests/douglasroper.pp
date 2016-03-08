# Creates the douglasroper user
class users::douglasroper {
  govuk_user { 'douglasroper':
    fullname => 'Douglas Roper',
    email    => 'douglas.roper@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7HGHo0BXtX21JGQSlkudXyRW3sxx34v4eZXMVeK04mpRo0kCJtfRTldPIEFQ20uSrvLXlkzMooJE58uJMhTFYp/cf50FYTvelnByHA7uSidWrSkNwtl++OVvA/BSVYuXyb4acxqQMqFzUFser3FuAn58vLIvn4qM2/wnkJ/lrBQEGjCCQ13n5lhEVmRWnHhTa0Td2cblQtmCMhGJa+hpnet8m/sdI+vQwB5EfvSvi79wZLc36GOg6FuuHuW8bFjCJebG4FMArzuanF1EclwNhEjKgOnRNqxqV61niNXzRolFEkqJtewkeH4iFkGf4LquMWZ5DkWrI/Sa3j0tohFQRZG9jNvguyWOmc00l6xqrFSWlHOQgt9m/OhG3NKfBuqsGFcHLD9Xhh5MnusaEXsSPZtO3YiD2TYk966zaJhk26FCaJCCF7ypR7LsB2mgW+LerLFLBJEhcliwAAvyHrIZQfmzH6GBfWag2edY/3HTwAK7a6I9lXQXs6twhcr30o9lSS6FfvOza6xavNw2jVFdxQazXHMrmLAhmiyCdqylAI/a6UP+mYTUXhHlfUhf1RbAjbXVfhBqxt67blaA/eB0PUb851MYOtPiJKP5cEA58XFQ9eCEjfa+YkqNU2n5GS4lSDRfMUtAedG7ddUWsZj7vMXUqMQrkIVIZTBJO3HYVXQ== dougdroper@gmail.com',
  }
}
