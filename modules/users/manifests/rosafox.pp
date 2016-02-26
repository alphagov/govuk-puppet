# Creates rosafox user
class users::rosafox {
  govuk_user { 'rosafox':
    fullname => 'Rosa Fox',
    email    => 'rosa.fox@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9D0hz7MNQL9ywlC4OfhhirQwc6dmUJE1hPan32rGq3WKVVtNCRyycB3UTu2GZ7vEBahYFx9Sxf/tbOAwuhGEgaOvGPepvslKltY9X+A92z7KneK12UyX4TTtuKZMAfCMKC6auoXyROuxPNpxFBrrmPHhySbftaxjjM5ORh1btef+GKyhbrqyFwzUq5AuylAacE3aiS8+A00FNs9aRPcnMMu6vDCFsaUKrDh4U9nIb3fa2d+mQAbuGpEw+yYN0gPmCE9x9zXN/rPXBxboTqOMnLvqPiuMebnV8Ec9/puSzYMREi+VrqMxun1/GsAh0GDvYIEPrKSYdIxQ4/Q4f23sPUF1UZBlqxdaVQFP/QH+E35woNQRF1/ulxxOflHMUPna36Cuw8aJRb4FZ+lyVF23qCNpUP1upa82aDadfcZPRMPk5nscrOFQJBO4JgTWosfofFdFEdgznuUfTi7+QFoVVRJ6SFNmeSF6Av09FQ4pkRjiNZF2LI7xgJ65ZkfNiJn/0A8w4lx9XioNNtfZunCPz3pQzgRSqZyw4SyZHZalm7MDRp1oNKrESqQy+cLPNWcogKI93YG3HckXK5hDGJOH1xWHO1jNZ99fr9da+ej0En5hRQE1xjQyFSvvZi/d5G4gabunjSzSrcfu2FYryr3CcFCJS8XOZUF7IbHu51g8c5w== rosa.fox@digital.cabinet-office.gov.uk',
  }
}
