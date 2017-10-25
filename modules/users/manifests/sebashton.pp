# Creates the sebashton user
class users::sebashton {
  govuk_user { 'sebashton':
    fullname => 'Seb Ashton',
    email    => 'seb.ashton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0FQ8w1ncnUBzjWeAyATnFsnym1HGwOX8Fi2227cItPK0xfLhwXhnH40Mbslu7KfCtZnB+aHCn/tsfl/72m4/OkM2Q4ym2B6TiApm0Y6hyJmZbgM9RKbUhaMujbLy3HBrCCstTQSGxb6MMaB7Vh5qXH0591bJKNCA3HqyA431BVHygMY3db74XHvZo9u1O3hI5ypAnL0cI2oh94EXuRFaSgmbscuXIBWSOdZfcSv4DX84CMGkFwaPM1z6aRNno9T/d0V5PC1LoK6XZzlNn6mO6kH0SMn78Rh9I8YKSz75NhyPviAUB1lGF3Ra8gQSsbmTqabt+kHx/tymiG9tQz+8yKVaAy7ciAklSNH4+ZNfejvInZ6aD6QA9l5Y/rXyS5sY0XN7mIVWBmsEDU3kL+WBOPV1utdMx3sru/WFzA7SgbUqtrU3Zei86ts/sF8DzymzQDIRuhyLhJbNv7WrSdhQYwtSonZUclKXeez0KxnsvMaIEheNGjXDDV78saBK1GvrWGftp/koLmpsjJ5aovd7Qd6bWAQ9KfBSsLG1QS6OB0PqPKte+wUcOipyLKpFfZcSAxmKoEF3mmyWRuRe/BPJHsIGUfXNOSis88TToVJbGyT3iVpSmYJn07iPbIN6LcV5Gem5CI/lHPJQfncUM8RFNn0/JvdHX7AoaK6o9BkCYHw== seb.ashton@digital.cabinet-office.gov.uk',
  }
}
