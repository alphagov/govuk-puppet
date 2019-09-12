# Creates the eamonnmcelroy user
class users::eamonnmcelroy {
  govuk_user { 'eamonnmcelroy':
    ensure   => absent,
    fullname => 'Eamonn McElroy',
    email    => 'eamonn.mcelroy@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPsmFMyduJ3thhgOVNX/uNp82PrAtgPF0bYVhXYTgU7PPXVqIZXI+pZvYqIPvV7Gx1nqpT/vE99VOYjmyQBvDMd5xxxSZL9E7SGW0sk6P+4MBayIEmA0/p9+ZsGyGhsL62UAs64FZ1ftQkU+28L7x2a+cV1uGxJmQ9bJ60kSwQMJCjDbyjuifj9Wj44xBufKrRDknOwvHt2R8RpJ/j5ROS1hLaHLtWh7LYay+qR4ZbyETrgMqjvXIY9TsOC4Uv0dmZX+y5xoU7ZzPECZuU/sDnZcq+hRwBJ2/RNIQd7xOW8q52yDcOTuF+O7+VrNVTNm22HPMKPPs1EO2DyOtSHDCDngoXqxp5/9rVcfbIeSDmV0ZoQAAT5xP0RJrKtUI0mSbjuVsR/r0yvuZGa+u+59srIG3wCkH0lY9BHy3DYufpQN+iuEBh/tM6Dq2GPP+gMniZZdfdxMdziYmdFPThff6LCnZ3l7AXecqsrfumoxx7Ae2GvOupQfbt3ZFv/8tSLDbjL87HCwQaEZ0feYlMZJ6VWe/IXgFQSCFpLjc77GAmmALVVCaia/+/EYk0Sg/SnM1qaKzfoJrlGJaZE4i1izppCvv3y5oVuDdlY3btPOks0lm+79+IhkrvvNdxMqcxGUEldcWHyBgIj4RLWFQv1+GoyBEH6Sp9LUCsAnJPkqzc3w== eamonn.mcelroy@digital.cabinet-office.gov.uk',
  }
}
