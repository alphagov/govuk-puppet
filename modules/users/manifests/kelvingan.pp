# Create the kelvingan user
class users::kelvingan {
  govuk_user { 'kelvingan':
    fullname => 'Kelvin Gan',
    email    => 'kelvin.gan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3Bt1NLO35J3mRPB9lskgk94G5SY57NIsjsMnoV+gACl9iz+/j49/Gj1YqH5Pu6/gp43dsTh110Fw+fo6JkFf2GfLWNd4QnODKvhRnTl+paZOKD/+fXmJNIApvEIT9ikLsdRC/iCY3AlqHGWS8zaY4sRh+mo+JZFJLfAU4P1esMsbcqjk3D+IiOnRkDgiz3+nYyl7VvNRzLAbyiCuDfHdC3SZMYay0zJFA01sZWtmBNaTvvBCW+5dBm5DD4a5dWC/SsZxhUhXkLveJIk6FdhYSi/4xvesi3WomeII+rB4KnQGG4NkTnsijIq16ufK/dZAl6BIgsfrgKwHLqMiFCa+IE+LCBFAI/Q8Iw6umhVuclaEMaqm3pyE0Ob9iqCZAdf8bOaVzsCOuJ+7LEERTzbA6oHEOjWdm0jkCU9xhHkeIAGMPzDsbSbwNSS7ychNErS962eQiFARXEXUK8FqxpYyb3EAf+9PijEXiG7ODYhPfndyrrfkxsMyScILUJhdcjxMTi6E1Q9ixT5Eq3F6CLdT9UmXbn37YmpbHAXfH4Xyl0n+9VifO6dXj8R7sgj3T79C85EjjhoBPcoiSgxxGy1DozLERmTfbxh1V0nRzgNo4iE+mnX4JhyNS8PwXn1wVxIOqnySzCdgZnjkMBR/uFFnITIORTxqcfpnHOL5xFDjfMw== kelvin.gan@digital.cabinet-office.gov.uk',
  }
}
