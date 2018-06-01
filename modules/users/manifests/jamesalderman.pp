# Creates the jamesalderman user
class users::jamesalderman {
  govuk_user { 'jamesalderman':
    ensure   => absent,
    fullname => 'James Alderman',
    email    => 'james.alderman@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXlTNKE2wuunRLHq2F7V2C90sANj/m7aEmvuKIF8S0LJGReVOKZ+s5hfaH7Ri6I4aUZD0E3aymohC1HM1mNAjDMO6OXHawmXcIeXppaPyRwEOOvpR/nbRwZ34aFutVWH7Ofx51iY8nnr9h2dNYL3hlxcjvXll2NKiABGAoAquJUOX5LgPBtXeGnn5ZmPLtS8Y83qBp9vPAe6Vje94srrb03T/kuWCPUrNcP6PXEbH31CU5KPO8VESzPfd5F6eUdvmxaHyeTqK2bVMPCm6CsrMX0PcOS5EnM4LUnFtNXrx/gKP1wM4OsuuMHzus1VBJMGpLAM6YOqyTqMMuq3TGk69its3iqrULEryUywAPc3AYjG1kQHGsroxdj6VqiIHdOoRRu1VzhAzP4pFW6adv8XSDJPuFXEtfDG1JygikMirpseh+FK/wOSWxypJNCKtp3sAb/I8yHxmM4ltCWAvteyTaWUldr0USGFW8WpTb6OcbpcAUyxCTBoiEvOQIK7BzcdPRjmD+u3C86lHuVdnhjcF+OLFzMgLPK9YP/TOU6r1zIKW7Tj5ObbUAyIVRWE43rOqPwO81QzgC/Ag2U/CWbW9YR9YHphFqAKNYPwOpaS9xSFWMZkg20oRfCwIfOWi4tFcSMPRmMsqAAzShvyHqmffQUkmaPbBq3Hi10/SFJm1fWQ== james.alderman@digital.cabinet-office.gov.uk',
    ],
  }
}
