# Creates the jonathanhallam user
class users::jonathanhallam{
  govuk_user { 'jonathanhallam':
    fullname => 'Jonathan Hallam',
    email    => 'jonathan.hallam@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoMNq5sjRhnv7vj76NDldKJ8AZBo3E7e/hIdU4b+aEvhYl4aIFwakPoZFgeC8johHWLqhQidAWHzOigSRD9OidzHiuVfEns2rQ/iKztPAoU7KJgZbPABH4iWTl35ZfYpIY3siNi+e3bBZdKp86/SsgP11I7xf8qLUQ3Lm6wHEcCh6KWDFJvt6uo/leJ8zcjq+gc2gUP1b+Fu1/awl4vk3s0mrWXGPYzmt6R0mVxv50c/2alzi8bAhgZ+7xU4AldObfoCRQkF2jOj+r2RWXQSPSUVtZ23pdzCzMRVFcq7wqP1gjo4q18fToP5YBPmQCBoI8zmBHnB7OgTVafjOekbtNO6PKuhiWiW6iKiSF1pGKTXPcp8ifLW6Axv5y1lZfwTkFBn2A+MQrjTp8ou64unzuVYCJIQAUMvPpA6KVKO/Wpxf2OtE4Ve86zTwE2iNr6oWhQPs0+Cjbf5mnY9+8sOPKDVGkRuJbFmiZiWHER1IVspfzi0fHyO3GOWQ3Vzc6QoZYG2h+ES0TrrH0uyYO6IySGcMPnTZWKlVWPB7BTBrHVm3TzLXJXCosyusd7mK4sMxC8yOfcePehOujz6KT+4dL2vvgvHWi2RRc5/03hJV9w1vxs6ne9+xuLzUOpQjZpZFKwfg5hcgoql5CBT5EOi9F8Rhf9BFk379b3xo//21uCw== jonathan.hallam@digital.cabinet-office.gov.uk',
  }
}
