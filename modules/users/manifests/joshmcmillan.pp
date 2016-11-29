# Creates the joshmcmillan user
class users::joshmcmillan {
  govuk_user { 'joshmcmillan':
    fullname => 'Josh McMillan',
    email    => 'josh.mcmillan@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCeeUcJbKq5TI24K5WnL3OEM/NeVJGVuq/tXWAEWpA2hWMN51KPQUnA6ugIcJAjmm3uzNrk0ev2w8IGBsfbHVqGV1T3wVr32zEvHzOvbFvwDxFoBoFUlgfYqkycmhW3pCGJ3JDXqTDGlZKQVnJm8014n9HQtU1hB5HaiQUQG/nJY+jwdeYmSNIQ3inHTmYnduEZQkpoMthpkYCngugEOd0kc+Mrp7MDvTRVnJq4M+nL7U5bzwSl5stBl6+HdaiPCZsqV10Fc6Bq4b0ycC6aKhv+CAeCVcfmAME/ZsrDO3EU264/9tvS4OmHukveyJkFFBXWzf1RbzJKv8BJ2UftOeRL6y9bliooJ0QvqCHLcb5gSKBz3rCzku8pSBurDENA5ozrpER74dLP66Q7ZzZIiKj1V6TFFS1SZHtBIIykj1p/re6nutSC6pBTnsBfo/9klogkr/BzuT6LjuXoEY7A6sn7Cm3ASfgoiGOP9H9XMTd5RZ2GWYAcC9FIuR9Y4MKw5QoG1+/aFZ1g5I/OMxJ4d6lU6zqxcMzPr1nfHK61TloOJWAOBmQxSRN5Ql7JmWt3cGY/hEYig38S2XJKNfzNts6gnSAbzutcf6AFY3T3SzCKxSaKvCSR6g3GQS/z8KVu6ibb0HGyFITYwyPmvb2VAcyBbqcgFB3zi6LjNgPGA/CwMQ== josh.mcmillan@digital.cabinet-office.gov.uk',
  }
}
