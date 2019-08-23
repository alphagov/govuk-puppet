# Creates the tijmenbrommet user
class users::tijmenbrommet {
  govuk_user { 'tijmenbrommet':
    ensure   => absent,
    fullname => 'Tijmen Brommet',
    email    => 'tijmen.brommet@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChxDnHtmrP+8wTqONV76/sHMAVkJeyeMs/yDNl4+bumjWum9+ZqKGTS6QvvZGh/rTKg5934ncv5xPv910NmisYW6SetjT4hWMZuqtnZKdLBN2YpSyqTjIWK0kpdKMS1linkeE5/6X38Ebi3UKP63VqTsDM7o4W2v/CshoIbC5+UKt7WjtcMsrijpul1leSw8gvwCtoq6z5N3vLqECTcv5/AoH+LxWDW/TYlywGqUD4Lfa1jJGf+D5ICK+StQMQ1RBU4ICby43htus+RR+NqMyDnQLkGdrVVT+/Tc2jQrj0wz78nVvJPULiG889NvgPrjXn1s9w45DuVl7i3a4c+X8yFGg6hcgW8pHcH+2sOPC5g1Y84ZARLj6yIr1ezdr6H5vSLiUBTauYuTOP3u2F5h1MKLHdXuhUKaV4jIj42jKpCwnKnd62uHs4oOkfIz4OFbVNCNDvUdBMYbRkJd8yDYHeSzbEFElSSSxBRtwMnfX1DJ21myNtI0AGzQMP27NYkroHQGLmbbHiLeWuFly8yuEmeeustdtQBwf6qMTcJeCXtAkzgTUDFYLsu3zBCZQN9wJt/OCBPrGbwn5cutaUMmn9RGEeUgqNYxzvKEwmF+1/QINAD3PZjk3byfh0u1LRYnppvQrfsg24wh5dtlTRzPfuPxtrWdKTxkPm3gLvqdJmvw== tijmen.brommet@digital.cabinet-office.gov.uk',
  }
}
