# Creates the andysellick user
class users::andysellick {
  govuk_user { 'andysellick':
    ensure   => absent,
    fullname => 'Andy Sellick',
    email    => 'andy.sellick@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBCDrnPg5tREFlkb/KEDhhpKf6Lx3QFg1zWRtEM5yxtQgnVBFSHmY8yJZN4clttaU2D+YToz1Y12giNq+LqEO+84eo1SIlAP8FLR1RVJsL9saswtxV/sgE+L7BVYnLEdUi7pzcbfgc9hgvfu8xMCJX5feTlILu0a+MBEETSXgW+6r3jmTrEZ2ZtXVf7/BSb5L2GPsnJW8rj4sU8x10o/PPAlDeOoxC5PxITl00B7V4yMmnhcBXGnRpdOsEHAvllLJkUDWN8p5WMxyOGWhmJB9drwXGLPCTR3e5E6+I06z2cbGf5ican7HxKkl5GuB+wl6BhJI7pju5q38IKwQXkNPidaIyiGPwIqHAXLJS92iNtSBqlb9WPTKKL4LeVwW19gTDe8srVDWi5bSv1UB6gYU3XRMcV7KYZB0EfE32N9pYDX6lkUIKLsKxhxASdOA0StQk2xnwXDuWx2qJv7T46vNhkZplK2EtIr5b7V2WiL5ibP5vRc/S2SIP+uZURm5g/QTJCchFT76x99q8PUOG/jHuOWwgtD1C+E9D4BGijbxve851pO/o48wKiRafYD8238P1C11yKiLKx/lfGDTJwvr+O3Bdyg4cLEAyAgE5w4sDGMHyEi36OlI3P/S6XyLWbiQww1nnhXG3xNodkm+5VJ8exfIDlOLV5UAZBmL/Q7Jqcw== andy.sellick@digital.cabinet-office.gov.uk',
  }
}
