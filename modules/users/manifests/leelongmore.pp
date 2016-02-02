# Creates the leelongmore user
class users::leelongmore {
  govuk::user { 'leelongmore':
    fullname => 'Lee Longmore',
    email    => 'lee.longmore@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+sUY2dMRxzAkLDF7O7xf3AabdYY66dFYXKAfgh6ITZJm31U3XYn27hCBw9Sn3FdoRcegIFEVD1Kh5XipUxN/sAiptCU+o4HKf/0Yj8qPtwQ4OHCj7aKmfiAE/COqPM7BbcL2Vgag9BMNXtwCcpAC3W5305PDnLHqpCFPj8J5dBeGMmoMyCZ06ywdSrGVTU8U7YaVwArKUsG9b8DS0xociGPaRQVnR5vfY1xKOCrV/6TvwjC9gcHRCBjReVqFj1C9tqKki+Z70O6DoYx/XGV6LuSm+feApXxS0Yi+Bu0Rp1MW7kO5mUeI+LD9EFF6L3d5xDYciN8k2vnVW7IQvExTb lee@turkeyred.co.uk',
  }
}
