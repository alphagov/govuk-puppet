# Creates the felisialoukou user
class users::felisialoukou { govuk_user { 'felisialoukou':
    fullname => 'Felisia Loukou',
    email    => 'felisia.loukou@digital.cabinet-office.gov.uk',
    ssh_key  => [
        'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDlxJNWiWOVbtSwe5DNNzN8csunIvCX6XUIAT141EjGZpOaEjK3yFtvv96OukdWTXPQXnWBDOIWg+fNJWc4LsfqnCV5CrHftykTqHeKakEcVX2aW5UrWvlOWHoTdkbFv+L67MaT2xIT/KWLYPliyZJOmwwF+W1kiFq3xVtI5qgMha7s2I3thuBo8lgLXsmxdVcYoa32MBKabNyknvZaF/l2l/D/wssbC/3N5zeLupJJXDRA4BWw6nqAW97AOceVH04twCG6+B5qL/M56D/YW8kMIx/XSSIAde4+yXCX0gLr5p4L6pNvD2vn/nJSY/rMDtO5rPX+XQjmM7eti50FvkflvGzuaUoSXb1sP+rwOtGMVQBn4pnB1whd8jZSQC+SRsXAgj7TgQfKLux/T00cq+pC09HrBPLag1TUcueJE65FM6mi2uyi+sYYOnVfr4ZhgiEBY+uFoOWl/TwnKuIAXXXD4aL9BXpOTdy3XxxEwHeobfv2AOa8QH8rGQXuXExTjaMXQEbQ6rnhUEmccu1fSTZt4rEUlv2a61Bp2XKcjvKNodNHqQwFXWbX+qmKpGTurPQZG9wqJzejUer1YYSuraxezQtSpM0ZREFhIQMSA5F137bCPVwLanJ3A/XN+1aEwjynrDALOmYOyJw/eblYCUX84At55tbDt+XdmIXiVeg0eQ== felisia.loukou@digital.cabinet-office.gov.uk',
    ],
  }
}
