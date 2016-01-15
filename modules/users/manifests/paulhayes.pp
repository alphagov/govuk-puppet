# Creates the paulhayes user
class users::paulhayes {
  govuk::user { 'paulhayes':
    fullname => 'Paul Hayes',
    email    => 'paul.hayes@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6jin6sAGxGXmfz3hT5H2H9kdv5W1ea5q5kX9/UuaPxLk4nGPMI8aQve/87WMcjmMU+MyrksoplM6rqG9kPel3N4sCEE/h24aoNkqHtJr43YoZLsnvKM0ymkbbIjrrPu9LafkgmpLGAi4lG69wGISc+WNV8jzU8ACmUqdOPmu9bA+3/cbdkjuFYgYka0yP2GWZ7a9nVcrl/f9k5BWY9BQ/roympm6RSnByPNIUVkQPKWnYFMRfPJsYXURpdfXP7RYvN9KTD9qIS3ZPs31GiVOlP9bMtzALyAndCx3ii/NnaypGwnB6IrFyZWkV0WfBndZhL5U64JgQikXE7wWlQRry0/GQfSr7CsynON5SZUHE2kOquY6QXU49ZsF9QTGe1V1PbY+GbrjpkJnPPQ28+dDqDMcAbP4h1zXW6KiV4q278PBp9RfbcX01xvQ2AH4f0QAlIFaAXn0H+zfVUSyaInET3Qot7GDmTv6v4auGYdaBz8X9JeUSzB3Vdl28u+fV327eC7tHIaso3IJzzffUTYlJbW+S5V+v9iYrjF9c9uIx+Fnvc0DTaATH9njVen8f0nOB7Ck6DxWaripskwZoKvniAbZAP5YM2UQ9k8Cz9Hlmj2nfE3v1zUk4wC/LyQKqz9wSMoUVGTtStf99TcSeKEoMF6wAn4ECJNEWF9t1ibPo3Q== paul.hayes@digital.cabinet-office.gov.uk',
  }
}
