# Creates the simonhughesdon user
class users::simonhughesdon {
  govuk::user { 'simonhughesdon':
    fullname => 'Simon Hughesdon',
    email    => 'simon.hughesdon@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZBt5knhKcE64MDy30cC0Hy3KWgajHN1yxaDiGb75Uh8D/21231ltWs3YRfMWeyJITs5EFh+Y8DYv4W8nEPIdLHEyY450Lw1ylXcvAQ1LtsZSXoKkLepF5N+7eJaOXcRlSqwYaVvD6MI216ENVnb3wrMfqIseBvLZV99/2p4BKPkAOkIYLhcIXSVOvxVdgB9kcF4O7rEmD5WOPy6lNPHnR/GmgrIKoPVzQGvSnXXD2OWdGEtDj4yePo5Lx1/BqqDmJKFmI+gw55zfS0yL0DGZ1v85R2M17Z+EdqkDjp4F3rT6Kh3E5tMpHW2PsLMci1VdseSbxuxsxfrr4WsKCK7cpbw9gzoQQnJOjghy5X7zaf4eu+8TVWsWetyZGKpTCJXikLoOhbjYbyLCTrynAxobJ1HrOnrmb23rLWS4aa597lY48S/cLOchhsm/poC6ejlgJuLnxxL/pLo4Tsh7/FOfTxl9Lme5M4inIjyOVPDJSrxxbau75OkOHFxFZbAqwjyG6nK/Gd0LLdaxvhwveIYW8MJQ+lWZBBjYccPiyJz5crPEFVP3MbrT9dw36gdepCZAf5a95BO6o+C6T7iv27EDMvxcMLZOaoEuP7mqaBxlFyc6AT1knIpIO4wQuTPGQInrzjrKA0j2an4PjIJdZKTF3ps4nrvK/8MOnGvLFT0sb5Q== simon.hughesdon@digital.cabinet-office.gov.uk',
  }
}
