# Creates the eamonnmcelroy user
class users::eamonnmcelroy {
  govuk_user { 'eamonnmcelroy':
    fullname => 'Eamonn McElroy',
    email    => 'eamonn.mcelroy@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCs69w7Ji2ElDlEKE79HcQWpkhewiNy2sPfALoqJRL0aKr/wQqQWuqOuUTr2XVx/9k0Ff2njO93zqVZNVJpmiPLCO186RhYoHQ9KzrOOXpmdQnJzoGj0eiVGOV/vB5BqEWPexaoYH5/BsHMEsAFUv6sLWcAgQFEfsEPSfOspWb49VDelCdj5aS/VdextxRbmYaIP0BBNre9GDSzkEX9Pm525/v/UW9HlAu6un3o32TlHq99Cgelq/qLd/Ab+SUq0DsbIoVQFZeX6zfYuvKK3nxE3eLkxxcPV11xfo5Yc4pgKgK/BsYM7vSEB9SEgyC1W+zL6urCPNEiGr1vw1KW0k6Q+BXRx/r58wfrB2tKu56JHJM6YlC8PhZ9WR/QTEHVC0Gf8w36IhARhjXg3CjNPQkmLk/E6QcZxgpbewT1iKKl6GDAEfG/Q+XcsuTYM889I25PNU86uQ5ziNc7nvJTA6E3O/SdG1E6sJueleA98/ZLdeXYaW4ORm5cAa/AKurOrS+WdJsGvtf7MG2rW+XeNtna0lhquJ44DCTY7tFHG9wV1jrZ3q6GQ+3LlyQVD61KkCpsFNF5KLrzaFAsTgEphIpiHr1xUv12DiKwqH3nRPyBBxOthVhMDV312CskDDiByjE6JHZwPRX6xFNWp1W3s3g0L0fAdx40JlN2ntgeWnbbnw==',
  }
}
