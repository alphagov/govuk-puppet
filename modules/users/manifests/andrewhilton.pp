# Creates the andrewhilton user
class users::andrewhilton {
  govuk_user { 'andrewhilton':
    fullname => 'Andrew Hilton',
    email    => 'andrew.hilton@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDsgTZPga/V7L26enrsQfyikw2doCv1PWuxhpvbqxOor8407YqRPUNuVdXBYeqU9cL8lINDKq58OEYcn+1DInCuBz3mQ3CqdZKEgkduxFMKD+k2DzLYXFGQhTqRcbBWMPYVddFZOYF4YQNWOuUeqFzK38nKTdo/FnP1bu1OPbifpds3La7Bxkh0JdafxDKI234Azoe+C2DI/q4A01ib20kqNqf7xbanNu6JucbuFks4gJbrVdugRpKWbGj1hvxA7N5xSPRuFqiaRWcyt1PJhN6ee7IiYzR2pV22RevA+2AKoQ9jfbkhvOMXEI+nmSWnasob0HeV5UmDsIQcc4QPNRM0DneLThaVA1gJH1sEVpSV4pxev7K72lt7TVqwJIbnoCCNSqmpwnUHVznPkCFGUNVNha6VmuQ47eH957IpU3QNIpgu9N9z5+OnAIAzpGfngVL1DE6pazoEOlI1naEHcxnCQMGM3fE9W8/U01qHRb/3/IFU04sELZ+e98ymkZPYId25T3cmt7pIxdYwegWDoJQZbd86/mFLjIdRVQS6YH7HhmbZY5/JB/NSqSmdR9PiXWb2yQqisw36UbwK0e9OE1u/OP8Qj3ZMhKC8J4BDCGASAEC9CGy/S7hafN0BGEwaiIVGM4VRigBvRBxvMMWeG+kOtwDt/9TBI6qGH+SPCkVX4Q== andrew.hilton@digital.cabinet-office.gov.uk',
  }
}
