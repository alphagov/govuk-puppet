# Creates the tomhipkin user
class users::tomhipkin {
  govuk_user { 'tomhipkin':
      fullname => 'Tom Hipkin',
      email    => 'tomhipkin@gmail.com',
      ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7sZPOQY+vKJBdyWJqsio+9sSFyAfzvMxlnKCt/FC3qQhRzrvqQsyPf0yl01XcVv7C5hrJCaOIL+WBonp/Ce2G5Q4oN5ZPrbA2on30rIm177V1Lz50TnwrcU0A51S7fmXjcoMNwRqpdYjf/yiwwn0MnLwTpjHU5OISgabsgIytPJ0HV+by7mj2cqdpiiuirSqm7nFo4Ng75ROGeoiGtzr5OvYRVGemmD//uML7fTwfFbbTkvxtAP1HxkyMKIblO8vakFboQKrkujUQSpHWSNznEljhKLD+hv6jnJ1kx0anIKQY/F8kkf/koRqjUfjv52GU2veRLmdDZJxxma5sRI2++CruFleFswSLzDdRDAQ9pf546afEPu8xgKFuGHxiVCykp1oRkXdC0O2CPxXMUMRx/22bfqHWipEXDdKXUUrUpU4ZFViyaB9Icz8vrgE2OAwTBZ0vWJaFDEXpmZsWluDfx2tcf0kfB8y7Xt0sbpEmyx3qZCDyaqdHcST+cAl87YnDYrilEZHR3q+xXPhRl/PxqWKo0+ExqFSU8u2RT+OqYA1r87YSdmMm10NIS2Czp5pZBcDoKhtV1vcljHvzeej98hQDmuayLDqowrbSjg33U0m1fbZevY36GimSFruWsVnodbH1kGpD+Fso2FILyGS8io/7eJ+Im7dKF8b9bxWlXw== dxw',
    }
}
