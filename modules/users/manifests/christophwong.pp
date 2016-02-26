# Creates the christophwong user
class users::christophwong {
  govuk_user { 'christophwong':
    fullname => 'Christoph Wong',
    email    => 'christoph.wong@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCq/VzTGCUdz5gkYUpc8QAUu5Y0QyzIDYSgvhc4DGlFmGgWyEv0+xvKafyD5LPgOhn+8b6UDBRwKSRBtdoN370ME43k4bLZ88x3l+sYrG6sFs9PhvW9ZYbdwhV/3zciK6bo3g1lcisdtMKZ3K7fgBgSpVkMoXZN9SXO7VjUO3+qsM+GuqEI7kj6LiG+so6vP0gcwh7Gm25C14fcIPfebrk0eIw/ZM0hFUYMLRmbsaT+JFAqz+8XGOiWcmF8vrBUWaCS9lZLYHpSFRWOoyezlZZ2IMFm0SGqNY+t45Z7gSZ6lkGcrzuS5L1rDZtiaAzC3PAsJTYja80aaEdPqOOyWG7GkQKO44QOsCIH2ER9A7hBbbzyKf4nvW/DeKPIE/M9F0OOH/AUBIpyKM+ICRdw/tyONax2KUZ5zHgRBvu7RMN/1l562VA1zD1+3MhFLmKFU95h/B5cE6AwwffHuuXgxba1/wpbCzcPKIu4kEqEWEFTtFWc57FbjoBcUIhHI8+JeRwTvT20F7Ilka7ShoFIBHWRcyNWtSzE+F48PDOf98bMd17g2u0MrZq5pXZNQOlQcX1Qyo6bgv55/h0t76ZhLoFT2z/MNLNYT/sq2p+T+WMDNfKgJaebDUS1Ra9OuoL2dAxfAuRrvobr/jxh8zBfJQknUXNJzx7Z+1a0psndg8eLvQ== chwong@thoughtworks.com
',
  }
}
