# Creates the marksheldon user
class users::marksheldon {
  govuk::user { 'marksheldon':
    fullname => 'Mark Sheldon',
    email    => 'mark.sheldon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKvOJ9kDTx0UzsulpoZz4iuM2KZrhzuHqiblraC+6u+DRZ8RmF5ZezuxTpgHVEjOkW/0OP6X33BXCMQyXncdz6oNNFnSyLQc92KhD16rZ/zVaLUn5zwlbRLvds7isrmjZ6nNcUb9fhg/z1mn+7JMdvhWrpjunrvhzx+V5GqVl9tU5gX2Ltj+GLawPcAwxVyuI2T68YfLppfbVX8unvsWQTrBkW7YuidSdJrtSV9kogcTh656qqgGqC/lRioPm+H2L0ycOcud8gton+SyDWmzE/Ie1YfyaPYq4r7r2tD0UZVJeId8MNY61eQQBubYmfEnhNUA3SeChz70SMSRSqR3ft mark.sheldon@digital.cabinet-office.gov.uk',
  }
}
