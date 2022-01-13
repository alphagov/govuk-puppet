# Creates the lukewiltshire user
class users::lukewiltshire {
  govuk_user { 'lukewiltshire':
    fullname => 'Luke Wiltshire',
    email    => 'luke.wiltshire@digital.cabinet-office.gov.uk',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQCe5wdi0ylyJCrQmjZN0+lRGjTapvvqyLrFAybqzek7WT2X7M3tp6I5wZF6sIKd+pEkeJHZsCcSfJaXha3ha8RChKrTiMQhVr6Ypf6vnx9IN+GlKTMl43o9zVLikPlsRcSq9mMntmP61KGGUjwDQ+PD93Y21+plWz8IAe/vpAkxbNcJmTMADWxTDSxJpPUeNoPuRUg/iAM4HC5415vI6tBA5VSXeThz4u7huU/8Av+qSifDGuVtfjCccnBBLof+8jt4Iey9nzSPTi+ojR/UI/Zy14RUWZskvtraGjA+2zXsRvv2vuhfzJP/3svYA6frcfmaeOgXrcyc0NYWuVtskiqcWD0bHwJ4SZaEG73M6NRBNMq3G3ovuXLvhNDP/+GoGY5jA/fJNXkEILO4mxB1OrvAzxxf9lnACsPil7e5prL/cXhTlhHkZSckLwWvI7kV7bY13e+FZ6ueHvLf5BUIen0Zi0buPyxiTi7cS2coGnobsq/YDVeusriFbF7FQygph6s= luke@lwmbp21.lan'
  }
}
