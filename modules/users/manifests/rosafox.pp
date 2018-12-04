# Creates the rosafox user
class users::rosafox {
  govuk_user { 'rosafox':
    fullname => 'Rosa Fox',
    email    => 'rosa.fox@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpEB70TRMFxrQU9OW0uA43MfDZvoJAFTmsNbILf4i8MTGaqofBzoEsjkyf54eqYvkIv86UFTD7fj9EeF5ADDCcJyGgBZqSRR66KbE4N18K2853IAfjfflWEVNCYLSaqBhMpZMwYUTAtSg6UGP8RtmyagD/qmU/WizV/WUoEUeFucvdk5ZxYM5q2rfh7isHVC5bDq5IgMCvTq11PY1w4OWdGHd2w6dqKRPqU+F2TXbPRw2RaNiRa5u1V3VuYPQtYTf97ydhABKugFMKI5O/e9HApUmZf+4uAd9BCK9q7FQM6wq9gnPrhxZlf3LVi8FctcU18gupIqjJYYQbPmbc+tIYbmsmg0L3DDAxlaoEZAkBUvtPui/8BTKEcRYSZVK8dqwcoFbb2/HpTnO21IeILN0hGjqqesbAhbCQp7dLpO/Xs5pVMPNs0o6cX9CBG9VgEeSqCJIcMrJtzFdw5lqRxBqGVx1AGDJBVgQUlypUnfb1IdIvSQiNFpn7CEsZOjPBSGpYWVU9j8KOXkCmDx1Uud7cRHSszNWy7NgtNjfgNnNt39vJ4KYW2Bjk2hex+P+Csdxypl+Qk8ct/raxOQkczQpEPrptBBwB7z45eldR3khg0L6ynFWKYGYe5RTXOkH3IWFDNEXQ3i/dtUMXgUW4+A0Xo/LMkVd6G3JBmMgICRJ1fQ== rosa.fox@digital.cabinet-office.gov.uk',
  }
}
