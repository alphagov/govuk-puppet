# Creates the jackscotti user
class users::jackscotti {
  govuk::user { 'jackscotti':
    fullname => 'Jacopo Scotti',
    email    => 'jack.scotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDdfYGAPo3kgt88Ap6dmba+bZDWjlPz/oGq845ljAZfotTlq7uMVyph6oip7pLGsKDqie5qhzP1P5zjrIQvTyTgifCFx2vSI92Mzpo6MhemQxoVBSUDMmqivK5QNuztdLQoyyaRalgNyWRhOfKrXJL9V6sNfxFoVPkahbKSixt1DLtUCaBmewlekvnyJY6nAXwaljZtUkgPnUkTRWs8e88jeSWVufd6psob/a0VRZIP45bBG7patBWsyM37WVYLK7UNecSrFyPKlFLOplIrpbFjGppKA8iU0EOlBnwZ7OMG8vPQ+uoUaZxyDtMQ1XOQ8Bpf2domlPdLmfjG21Vv97luIS1+en/VF0SxWQTD+0UM0kFkqCvfebW6bBvhttlt45HUMtqvdz4YeXglvmCZrWH0niyiPwV9QJ2DxtYLZewp8gdzWpysFQBLPT5KStfbh8l//AcmukXVqOuPk7dw1JjoaHSWApVWM4Tr133/hxgJkI8NBqQZLdoRHG9Ej8BIasOciO3WomsaecCdAklJZ4bLI0kTG26KzSNzIPAWwxoA4TEK/6msyvYddMq+U34n4glgPKQ8rmz+30FiAKiJjKsxsGCpfGgdAQOniuV4xzFVCx6rxF4R4vPuUaP7o6iHGPnYVS+Z1tkzWW7MD/87ZheGVez8oFISygHiLHR2fDLwRw== jack.scotti@digital.cabinet-office.gov.uk',
  }
}
