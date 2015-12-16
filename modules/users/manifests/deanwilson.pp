# Creates the deanwilson user
class users::deanwilson {
  govuk::user { 'deanwilson':
    fullname => 'Dean Wilson',
    email    => 'dean.wilson@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpJK/L4n4SCWOr3cywl4EOk2E2b473m1O/fXlXxsGUiAaleevfNuAXSYBepJ6bGYk9Iq5AP8FWvPjQ08ZdAj2ZdF0hAYKzRlk0Yyx+X75w5g8u5y/cOh1WUcQI5hb5duxwG7Ix/RuRS0+iFyz4ZFyYhS7sNp4kCuKfyYKp/sXmmnuKIFEk8RG8wHtFQzqeVrPoWy65rSDGVDq6Z1Ff0c/g9ZsBczfy3Jn+BzksvQkc3rgC08RjQvXsQv6JMXOZYXeeoyZY5+8D1EOv1WakgtZj/8NPggqO2R7Ht/rSB/2Wjp2swlBPwX1aNdnFpInc+RgrE1AOH2/OVbvs1fl6tKEV3QBYP4a+n1Ke53JnELhkORyK/L1+UXvpEod+1XArTMDKQKOUtRoLVpVFln+raxAStirCuHrGYs4asfTM3+V1Mwru3t5AvUz6y/9/ehlWfQHxMU6SVctxm6ASsxhEXZ/xD8h/SBjp2m0rO5Zw6ReXyVPyEdEYkjbSX+ZgY2G2+m5ikJqn3lz6SLKbll4YsPyppyr8Dt7E/nqtu1B3mpm1Ia43x0Wl9nnvUc2SDrDrrNorQB+1NnSN/CJboFi11dakwOvIpfKdH+tKdSZ2QyC/3nLe4/MmKf9sdUAzj7r2vbk8Lfj7TqwHNpRuwO5nmS+RfBvgqmw7C2MOMiEydOeE0w== dean.wilson@gmail.com',
  }
}
