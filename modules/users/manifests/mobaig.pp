# Creates the kushalp user
class users::mobaig {
  govuk::user { 'mobaig':
    fullname => 'Mo Baig',
    email    => 'mo.baig@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChAkkSIvHWdYsVq6pRh5e7uqMtgWpboIQm1+2bH2+uFSexyA1xgqOspvCO8+0gQBRG9ej1Hxdkapxm3Yo/02vihaMyl/p/Bi+EFKNoPlFGDuSPhw0CFMhc8kHSsKdYuYoF3wmtRrbgNAEWyUJwJFPAfKIWBPpDF9U9WaOfQLc5+4oO5zc6NVZvcv9NTq7CsJe3VH035x/bRl9KRYNKWMb1L370kMpsLi2GP6CMpivnKh+fk11rGhup2AaQ1BH+DWMdcKRzzHYYrSrmnxtVqGuKCP6rKJJ51Jm2d0nhROiOHnLOEH9ExgQp8GZ+p5tyIbEXx2XpFx5AsT1HqTUea+tr mo@mobaig.com',
  }
}
