# Creates the jackscotti user
class users::jackscotti {
  govuk_user { 'jackscotti':
    fullname => 'Jacopo Scotti',
    email    => 'jack.scotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2oDxuxOZzD1cg0gld4EVrVNln+TWkXjweU2nBPUmS1m27SwqHr4NjOZoOCnddUq84E2IJLS3lBTtY457RCPx74bhR62x8UbAyAP7JHSOhrtIR1RLKgRhWt+nmoYepMv03DrvUi7sjrmzokP2QpGu6+7iBnaKvIHMBE165wmgY6EKBlKWJlmRKYRP4G9ckSPZqflg0ANoFW0lmxgDuDfKM8wXXhIygx5CTX3uBdW44Jc2iSWyluwsfxSm0Yr0FPR723x4nOPimRcOAeljDIxFfjzmquNmLsiJqKMY7YItPRme7DGhjNC2w11ZeM4qayG3lMX+CU3uM6Fegi5LxRnUgNxrtTvv1ClAq1wYXB/8q2lld+5ViCbr5hRifIwNMi4fFlhSgBJbxPYHF7D4wPjqLjW3zE7hdT2evoYcV3Ww1nnjaaU5p/xBDQitYPhW9VGtMekGCOL8Oyy9P7rHsaf/2V519n7x3g7C9hy+u7ey+rdONR7Dh3DMA8wG6BbcLPrnK1qN/OLxvxPPeLvzBJoAs0tyqji+SUn07nLxrjQt7RW1bjbYXXSq+hYmyMuE3f2gIMNqsJNl1Mryf+giNSw30bdzLaREojZB4ugvQQ3LMSJjmlGqgqkFMYXTSFKBGjDUgn2p8B4lgFVnARLMO/bNGHv+zu4eamerllu7ApoXXjw== jacopojackscotti@gmail.com',
  }
}
