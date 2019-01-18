# Creates the user dougneal
class users::dougneal {
  govuk_user { 'dougneal':
    ensure   => absent,
    fullname => 'Doug Neal',
    email    => 'doug.neal@digital.cabinet-office.gov.uk',
    ssh_key  => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoIBJTvtjlHne4wBgGyPyajssM3ixmLoo2RDkW8XnEprAMOEst2IAMYWCH4gEu0my3R1Da0vUBxIBFLTtH48JiRIvijr/d2wM4g0NoSrXNSQgvioXuIqUSv30xgPt1f7zgwjXoQGxPI/hNkfeJEfRGmuQ3/06MwZudcCsy4EgDd5ZOhGXZwOCcMoNsuW2Pn7cCFIErkY5h9fv1x2OehvWtf0Xk1iMTLJ0416xz5xTDZA/EZKyTPVKcla4/s94ISXOpDLZmGJPfVfuFT8yoZvFMnwu5fPueNl+uknz1+uGwimuveAqUs6EuLHu1ZKEWbvF404jPDd9CCQty6qVylv2INyA+uQcgjzNjfRRQO52KU0xPoalkSfUo73w0nFHFCKrzwWXH3nhFGbtlC3osAGaxCQow6FSg17IsgRcgYek56FUHskEeV7v15KYgoFnAx0GJn3SE5W4lxw8RLJLfLlFrPPwCJ1I6zA5pJnqHUJEH8sPHxvyws21UYU5D1Dkadd8j+Z5TOHib8exW3vagxNk1HlLR2jb3cTgiIo+LqsLAvoX7fTUrDmXFcQ3JMkUHXHm5kVu5kxVYs0zj75cRJk4xlW0p3M/rsa4aXyPGcZ8NYnVGaQRbkBIwZqUMHRZhJjgrvIpV6FGgg01WBXhITTTLL2/PRQsnF/x78uaUCu6VUw== doug.neal@digital.cabinet-office.gov.uk',
    ],
  }
}
