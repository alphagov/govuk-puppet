# Creates the bevanloon user
class users::bevanloon {
  govuk_user { 'bevanloon':
    fullname => 'Bevan Loon',
    email    => 'bevan.loon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJyRU4ZSa7FiKTrUr0uS3YAY6ry4Q0wZEUMszsFVgoHthQFfUGEpLsCxKCJY5cKBE9KQV8PEq/0iFw+SadIK+Jko4zVRlXVyC3WY0mlti9yc3eAsmLnPoxOC8sfCHVBmgW3lBNQP5Of4HJz/8HvDmlNOOsqBECM6nUnO7yDKq9pgkG7U2hz93qfv1T4qn4UnOMkmt+iO85tpPBkg8DGwlGO+ufKhzyFxQxbPnPtxr6vhhqKW7wEiaCSmV/leJlDuThN74DFoi0KUhcx1Hd76pJX5GxZ90N3oKvCx2tq5x7W+2hqw4qBjBXvtnNFioHkmeaJAjV6hb5b814p7VJS7U1X2YR89hN1+QsNDS30mwAOV1HpIDb+S3/iVPEdF5sZvV4migzrS5g1dWLkgVLpuNem8ifF3NMHg9wpAv8jusw2eCEJwvAdzuTUfU7r144CboR7HskIK0690p2EEbl0pMaEnFoc+3Qg7RH/TYtFXSDqFhDPo/FyVhwU7YgxlXf0Ypvk/lnrBDPwZH7Vzuj3QrrPna+VWAHF4ccuRoT1EJpLCR4Gc0X2YPl36fAbDrZpe9qCamEt4aj5yy5m11/KhurXnszqGWO2XTvgaGlxedXlKwzagCdu0HRlpofRPwp/JX7ilbwRTbrDEx+1QUhwuopqpOex7Clci2o2CAswsMXvQ== bevan.loon@digital.cabinet-office.gov.uk',
  }
}
