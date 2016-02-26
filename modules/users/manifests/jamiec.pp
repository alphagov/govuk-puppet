# Creates the jamiec user
class users::jamiec {
  govuk_user { 'jamiec':
    fullname => 'Jamie Cobbett',
    email    => 'jamie.cobbett@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJHyDmfrVBot/8xcAwPLv5uHRpvRy13iNWYW0FGPol7hgcrr0CAESK+cYD7LaW9PmX9dR0X65tAhp4nZydmiBKjfcoMKOcMELxKNNoOzMnd0vDI6emG+ldD0UPZsZwMvYzfYLw7ZaFTPlK/EHZe7/zQ84PKVvtV16LKn17sP6Y9DgizcrctUSbjwmLtwBhLaAptq4wyqeJANQf9D/4jyvrTPyDGkZ40cl6XiTcTzXBPUkdTVA2r66c+sg08YgOgCBK3iysm6yKadd0xrfWKvBnin6ZAClyjJnJ35gZxpVRbczvSOmwiY8EkiCzbgFyoGIRUyUBUfifWoE8BYMK8aF8uQPvAvdkb4bkfcTiQTT3LmL8WlRqosGqmctMwyHaa/o+HNMpsGMeB0s/uVCRcnspuoJV/JHf+61UUeJP7PhwefBnMozqdJqjJSFRP1lhONUwUQR3zRh0BwkkyA+/TxYnByhLwkRiPe//O/DMlSZqW8EH59aiZUOsbkOz/WxolpgNg82WSE6fzk5WLTMuWZNRJuJOv7Bj9N142lJCCN8jowP+dnm3MDN/I8sIf1We4D/VFRoeMbbs1DBf+N9WQrpGABEKbMeKivOkTT/AYVa6dsqb3zRG0QxiJfELVDGlSE62/c5h+PaABIuvxWLERbz32TS3iCjtw383BnWKhcbAKw== jamie.cobbett@digital.cabinet-office.gov.uk',
  }
}
