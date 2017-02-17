# Creates the pmanrubia user
class users::pablomanrubia {
  govuk_user { 'pablomanrubia':
    fullname => 'Pablo Manrubia',
    email    => 'pablo.manrubia@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCdRRJ1fVOEQUKgZaOfvUbOc9WVuMDuphYZmbJJHe7DwH8t7CPxrxRLEHSNk2ztLTa1pIQoRZ2QQxFmk4pyLdNiuizgucvJ6Lwtj5zpoqnKfk+dRZCi8UtAVjG6CqaYG6xOAKPM0Vfos5kkKT3RKPQT8adFL9nxmIVW1yw0A8WujmPgK4dnBF5giArUw+MqzoxT0pImvPBSzWXqcxWoXg9yl+Q/0LL2F2xYWEiChTo5ic2YXTRcQQVSNHMfSTSEncaBJZlkf61flAji//p8sXSlYyWyeCMIi5Y0Ieo042W8qm47W9KeiAQbIKL0ELUFRbzVRt3wKMoRF8odjOLq8IWWzv90t8BTGRWyTxEncmPe0x5OYNtq2QcmjPykiBxNs+JKRNDjtZkcwAXCJnWCZlQiSlcpjFbI+ntzdFfJ8eFUz8+9nKQuewDVHIZZcJuLltPIFxjO1c2xF47aFQItYJcScTmYlQJJk77wTpG9HpOOJ8U518nxAgAJLmdGO8WATcOAv+n5ujb5aUNCX6R8FOVaBRhpjHCKfdBOFcTey91wTv6S5l0BtK0joAawtCo9JnsRQShgpncK+v3j+UIKWW1zKbXbrY9QPGRPtFh5R8/+z2KlSeMTUBsvf6hSsmg/yBuKAH0KfFpIZ6Zhq/yFF4jr1OqfCgK4TY9D91RtkfcTgw== pmanrubia@gmail.com',
  }
}
