# Creates the christopherashton user
class users::christopherashton {
  govuk_user { 'christopherashton':
    fullname => 'Christopher Ashton',
    email    => 'christopher.ashton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9li9eNlp+KvuOpkBvkuKgTx16RLmGC6Qogc7O7A/aT7Q6m4EBOU5pb1+jv2TmybTzNXP8TGWhqGa9WJuOkUCR9K1Z/CFdu+hMPHpzw32P5yv0uDaJJCoOzYIrM0EQ7QWq7e9oIhJ+rW+66f//Ux7urifnBEwum3DMPLqsFaGCwxhD8Ydn6inYtF4IaY125YuLH5Pyq9Bx6/wj2MsZPxjMRM7kIoZrCUh6gKvt1OGTwRTHAnMFp5QVhS2s/Y7M0fmIuhnQ8s1UGeTAQoHX9ZahrG/hJd+tqsMk8NogQSHVAcdqZKbHdIAaEG0o72NTh8vUqIGPTVZ75ZhFEzppUcpCfcvWCmKWhDtm7AZnB3WZbV5fHHT3q2eB6nbMzzHHRzvrYDQR4DK8YIuj4fwLVV+I/XErthWos3tLn/99ME/h7+aKqCunNix7EWa8zJpOp2H8CBB5RVvHI44hgdsyXUdbT1BG/InpJpGYmNFMSF8DOutS3FC4yl0PM5OqAE51uF9znLF35gJyoavN77RD5ykQskTZsUtV73zFWNF3Dl5fbOj+VW2VbORMa8GgQNNKaVX00u8aqa28jTsDZ2ZIyucl2Fm7FvFHl8lJg9q5D8wxixGhwYMgskaumDGI+e3LP9SiGrYOyC0B+Mhn4Eiw3aO+n84ibQIbfHeEPYUoJXpiyQ== christopher.ashton@digital.cabinet-office.gov.uk',
  }
}
