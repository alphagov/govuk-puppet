# Creates the mattcottingham user
class users::mattcottingham {
  govuk::user { 'mattcottingham':
    fullname => 'Matt Cottingham',
    email    => 'matt.cottingham@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNf2T4vI0Fq1DK/hrv54fN7WR8IM32ItDsiRcOmsq807LXZkxn0Hbua8NP1KjtUt1Ks7kxQiXYp32S/LNi0G/Sr48BqFhCPFpEtOUexrX+wK+ndXNwP3XygTPKbgoPV/IXyDdjSvqOVmQKbWFGYCMn6+nGA+JaCbvt8Ink7lpRGLrf8W73rbcFcPCNuOtWvMT+WSspcqs9IifvwWaHDFX2Uj8DsE3rZcaeoxXPXNxc2mZ9/tKee6Ceg0Acmsywn/YsEwAv55ng73WMUE5y5KximZwGKBIQjjILTryPd7euztCFr5Y4UMEDbDz52ovmD+jtrI2hxRygAimTshJ5jeCb matt.cottingham@digital.cabinet-office.gov.uk',
  }
}
