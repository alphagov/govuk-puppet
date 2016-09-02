# Creates the dazahern user
class users::dazahern {
  govuk_user { 'dazahern':
    fullname => 'Daz Ahern',
    email    => 'daz.ahern@digital.cabinet-office.gov.uk',
    ssh_key  => [
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCo1ECxphkHId9tlIC1kZ6X5JkL6Lcu0vhFShCuTRSSxNbxt9K4LSaFFhNkwv2In8YfHPYt9eOT9trCcdihxpDj/FZDKsmt/xTrrIADFABHGRT2ulCbxrUcMX97okCalw3ucE/99+xvw3LmeZ/8jzNN94tK9Ik4FFUd9QIHq6t9rDq55NuGcwLtxeqJN+Jv+BdlepxB0cszHfsMMVfHQonmtARHHegxiD0KwfFcj7RW5Vm8m7joJ+cY86YeiIGkRMyMmi26CjSDnBDIq3Ti/jpXUcqRD178ZeFE0GToDPQV3SvRJLHXjSRGSNmGiROrVFVj1lkMY365aAh20Fu6xRoLszyLSLyo38C05rSKQ1pOiNl2YSqNDwQEI94opHrSlyNMoVUulx657yqOSvGmjfdefbyzIO+3q4RYBhBkn68CcZESJ/VKNLoBduGrbkov+gvqrcJQHUVSa7hZfHYs4HFLT4BpU1diDRSMzp4Sjc9Sf7IlR5fOy40RD+eEaSmssGF4afX3QkuLDzUPxMX071pYPSos9+Q6ZCrE5DH1tPE6mMo6DpsIKrna74sGljlLiqKNQ+V16kKaXKTS7DwfjWqlD+w0K9gqOaVR0hglqZN5fBhyxeKu7mjwwdEk3l6ISN+dvSJbrkDqaNXFk6M2an9gJgqyFjKoPhX9lfF6KnZrXw== daz.ahern@digital.cabinet-office.gov.uk',
    ],
  }
}
