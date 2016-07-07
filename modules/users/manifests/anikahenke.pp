# Creates the anikahenke user
class users::anikahenke {
  govuk_user { 'anikahenke':
    fullname => 'Anika Henke',
    email    => 'anika.henke@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChgaQ2ljay5DtTtSySEwXPh7Z4/tMsi377bYiTXN2IB3BkXwLlUswu7TcCr1keC2r6LyuDdhtqH6v5FxiQ8xPwwTMCI+p21en5qmfstR8DF6vq7aaZZXDAHiMbSzIkfjEjMSxeGYFVfPBzK1+iDYx+2495s/Zhn/QtsjzDFEE+6DLpelgg7U//eMrWk3yOmCCUGob6LpA7ZrCOdnsCHDXtBXTM13BRW/fpQgqzPLcFcfRCIDqSeCh6uw/5BORgYMZtVpZvdSWKRmhYRgse1Hy7W562tHTaC4GwYNEw8rJw+d8M7hs8qK44LEZ+1lP1YJqQYEicXJAdI561141huOv02QwILLkPUY+DcrLJQmKYY8e8hs0jRrvE8QwL0pR0hb5Q6IkFz3iagaNA3fpbBAe1BCI/dwyzC98qVDxbxHXIIkUseJPqQpzsNFfR0v4FswHkzkqRtPdhWIzMSVT02MdmK1hcU+DZhmHEglKSb2YgxsSqA70MUKTlv7paBsdWTnrwjSexwU+/GbQ8ORn1GknSe7iXaMMctQMZvewS7zisfKOryKnznbxK7mkpss0fLef+F3BWleAOCQeUQ1JbrLxJcGUWRh6Am6SPDWG7ieaKE3sys4xKKIScjAwIDmXHpnkKyCfPoRoyB9waXHNrkMLyYBPggy+jozzmuxDNxSUMnQ== anika.henke@digital.cabinet-office.gov.uk',
  }
}
