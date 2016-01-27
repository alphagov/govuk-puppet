# Creates the benlovell user
class users::benlovell {
  govuk::user { 'benlovell':
    fullname => 'Ben Lovell',
    email    => 'ben.lovell@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIeaO9shI8KzYw5oQYgEsJa+pMQ9KyP5TYLbqoY7rjPpQ81xLwZ96QT5/hOZxsPrOIAd6JU9jZp3m/Ll8cb6xJOCJ0Xu40gyRJabkvRdtpT+jrKPqDG5SeZUBDxmeRb8uRP64GVI6WLZjtWqTWJK8XhOv+xiinqZEvDPDNKInNsxmQ8C0/JlmNSArCCD9mb54fViX9+NLEpDzucxdKeSmr5QR/202HMgs6K6r4MMJf90FmRTxS4dcN/TTo/ipB7wyyemoLSpKKIWpeJ+o5yzJNN7KH1UGZr7KZjC3sChihpWxH0hqYkbb6i5Sfx9T/vbGiM3n91fnszKyo0+I4enLgKqSyJBK1WL+x5n6BbQOo19QjozcSGOF9iHKx0yYIK2G+20mRC4XvwXuJb93xgTz22Tih5h+cq5qqWzSeEZ0C2g8wusqV8Kvai7nhZNfE1loIwe6mtDeCyHVkvJxqrRqsy1zcZTbS13VKZZjxLj1AoyUq41KoBKyfL4VvTUtf693RvIOFQdn6Onz4jVY0F6vzyhVDFD0vX51GqsB1+hZ144hZ49S1kK0sigPkehC63Yrak8MxCCUDhTj6rz02SHn74mq+AX0E2ZcKldSUQMexaKK1/65jjf7GKL5nLOMGJ3PN6tZS2Zhyn5jarCjyopQ4VIphxIv4W/+3cZ15goLGjw== benjamin.lovell@gmail.com',
  }
}
