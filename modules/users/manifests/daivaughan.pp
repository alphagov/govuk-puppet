# Creates the daivaughan user
class users::daivaughan {
  govuk::user { 'daivaughan':
    fullname => 'Dai Vaughan',
    email    => 'dai.vaughan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDj026Eo9jrE6cRpOSFaBFzAEU9MjfTAV1miv9kbBJyNj4Mb6rhwWPSbwURYqee5vYNWcBMysifu2X25P52GF9/CNDXFiIUsmiqjybKyjMccdfuKaGJ+M7xySqfPE2VPli/ZDwOnoKjk4vUeMCOyUtSbwGCE19vYoIwNk90Lgo4mn+fHwGSCDsSOEH4eYl2HuIMnBjJ5V4PuWC35uOgIfY4g83osZ893CCNKHZTTEmfOQNEywcvsA/dKkxqOV0OiDp96w+XFoHqS1Z00VMk2RaOaK+CHj6FLgLSd+xGdXXmeW6NvVoUEkuGkbuE1Kag4VW8dlhYaypcP29R58YBVFfpOxKD5j2+a9Q+Wi4bmMejsEGXwfQG8/O6pMFZeFYPJL1W+x0YRuY9L0hBGOoX2BxXPLkIvN0jdEf/IS4s8b9BE+D48CRw/VCW0CkivcNQd6/6KZm7YYJ7D6i+F204WaCxgqs8VIP+z7leQPGMAShTxqdjFcZRM+vv0ZkuBF7I/vnu3zmehgurrxdG5qattqSUj3FJ6BqmbNNI+dcpOiL2RXShLxqs6nJo05Zx5ozJeGyvm/23wNcZ3/ugO4TB+gSkOHRbMpMZNdKWVrTXbXSf2zOTPOsr6h0ATjCYx+4Aaog5v19XO7MrIfC3SC1X1MBhtU5Bkumzbl9GYYzuNYTL6w== dafydd.vaughan@digital.cabinet-office.gov.uk',
  }
}
