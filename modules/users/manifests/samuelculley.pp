# Creates the samuelculley user
class users::samuelculley{ govuk_user { 'samuelculley':
    ensure   => absent,
    fullname => 'Samuel Culley',
    email    => 'samuel.culley@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw37aQ9iz4nmNrXfO+Ioq17TdOG0bIPGGT9ZOSL9+k0FVf/vUOnDzMtr3o0PALVbP46XIysrnJMufyMwKWBNMC4iaQqlYzqwr4MzJg1O64yekqEMBqV0kUlwAq1gW9ZDEvhrkJamUK4PXzOMC5rbUlj5pKUTfW60kurD27gMvQ6kvgygE8UyVgfNSrqtU1JhVTfm1kboSaqSFDIEDqxU2PLzkpB1jY4Kx5MQlyR4is0TxWSS+x396us5EYPVcNHfN85qzk8Vg+W0pWsbzgZxdpz4Rfh9pL65E55vImFExM2DURZoPPUGZjTbTn57u+9r82qepBePaLd7X6jGkJ2g1/DNR6+gV2mUvYbgwkrBWOcIykZdsZrCkd/24wPeHrxn9LRGEGMmjR5mQxleQA4bpArbuPDrCmKai3My8G1NR5pqUWh4cHDGr6PSOwWW/1Q0puUz7ku8M5SANCVQfscYHZWbLMh0Q8VN08j2Jpu0ZH19uxkmAr1mS7yiFIr7oMiwvMCCpMWCzfk1UZg/L7jqHSxgWK6ody4gvzDh1002jXJOUi8DUWy+6cLnzeobI91OJ8e14V9HkiLf8h9hEaxeD36ACg/9s8yV0qpZ2cqSQaVn2sn4CllDUUn4iOw6XvdhIUvsqbg1qBnl9y3W+oUAzE8VzIWht6VSZ0yYRdd7ZX8Q== samuel.culley@digital.cabinet-office.gov.uk',
  }
}
