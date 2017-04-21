# Creates the gregorambrozic user
class users::gregorambrozic {
  govuk_user { 'gregorambrozic':
    fullname => 'Gregor Ambrozic',
    email    => 'gregor.ambrozic@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrAwhc0BW8cxp8V8w6a8o65Q2pdTRz2p8PeafFc1UzMqdR24IEjCcAAX41vK2z72IRWVH2c9qoreUsL9khQtkqEUGUdpJtgwRbNaI2VT+3RvTQyBGSXxvVUA61NS50+0LzQV0QIzWVN79T4g0k1zzsouizzU+4sy7CCewQPc+N/Xiz2nSgwTNGEDgqP/ab1EB3GvIfHF/U7QPDO0ACmTEoABnMhig3GoEX0TaNT3aQnBjcVesvcKvR3EjUqcefrnRIlbOrAlFXo2+BcXqtQMsgdNR+hZxHOP6hMmWGRSGHIqTUMe7xrBuz848W0ZyYFUAcJnppBl3/wVxWrwQJIm6x5Xe/bXb7ibyzf7b+V+qQJhlksSTq48KYGFf0nmzM4+V04rmlHAOeNJtb+d4z4geocEEFzQ0f9pLDZqheqzTEXDs9ikNkvdPKvYtufqant96bZTcO1TtwXFndbuhanMuaAs9x9q0bqaGoIRuanJoOGKsyMB/q5Dd3ZwgSd+WuMV+MSUc03pDUQ2iWzd3BYREIn52LHV/deBBa8jgPo3QnA+d+5QWx3n0RD9R0u4SFtLYiimemCRUIMD3u5VZAcA89Qgd85HcZdhZW4bqh1dCm5FTvgW8wXGhdNXiK0bM0ZcupMHQWjc5NBquq/WdU/BffI8reeHQszFGIWKX7jIsDzw== gregorambrozic@gds',
  }
}
