# Creates the ollietreend user
class users::ollietreend {
  govuk_user { 'ollietreend':
    fullname => 'Ollie Treend',
    email    => 'ollie.treend@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhDklCZYNXHAmhMamd4ZPFcRraR41KHWVUJzs386k1RAmXxdYcJqGOsy+wO7YeWPhnJ4A0WyksL20y9DMEI7vdBSKMRR/xESEfBymubXMZT6jrxmg21QvDrXWZF3XFC9rCo/aLnjVmEEWLyBfCtQ04u0CYVAcAo9t3ng83BhgSn/pvt67tvg2sCnlyNqKEXI4z5NJTTXkSK9mrMeCK+LUMdcaJwrPl6Pza73P8xPxeXNBABjBPpTAsrBYMpDcO4DXO+X2+pTH0LYSg5BedWCchijXeJGYc5RTOOnTL+a/BDQylcPLclBrC1km1ZHaeifIMWvepFRuEHc9uZG3o9iD294fecYV62sPbFgB8TSxKmT9E8HsUlygaHTHZdmkOZP+IXYxa+9nazoQH4wyaDQoNjBuLFQJMt1wSBwALf6Xa2mc+dQz3dH2KRfnLrkfm9erqYp24rO2Wj87GEPssWu6nc/IjOTFyG+p5HBH4b8XCjfciEcpwcVBnmAlC3xFa+9G3veLzOu+vyULN87qDyeSfGtAr1FGvqg7MfOlU2W3wAeGpLLrd1U6Hce6Fy9f286TddMU2B/Wdoac9xOYibvKBEyABwaO/VFuQmkAtMfBXJZsHuClbvnCZVnBRrAwlARWSum8dCvjtA9LOwFgOOsbHd+/RW1bESTIvgMJflFrhKw== ollie.treend@digital.cabinet-office.gov.uk',
  }
}
