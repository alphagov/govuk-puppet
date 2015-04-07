# Creates the paulbowsher user
class users::paulbowsher {
  govuk::user { 'paulbowsher':
    fullname => 'Paul Bowsher',
    email    => 'paul.bowsher@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7aFhhQe+hRHHWsSd5v/uH1pyKC0bZi2UfAltzb5NFdGQRRCemCuqASdJ4s6of+dK+UnFmdBCaWIhFKe2Dxvp0LZLwgPf1XhiUY2hO60b5DyzHJ9mLf9GW2rbwiIeaNx2ONMpnaKBmnfXF9OK3Zptk7phCr5+DDdkYhCsX0vNVmqy19pWtA4WS9vSoevXQAUGDd4QYMjFSiSNyBQUtg38fyxcXcPuu0gK+hnN72zvAh/7Sv0+aOANYTdlR7/g4F+RScPzwf5Pbh2udbj75M+/UiG8MkvVO+Va7qipIoMfQmADGb+fnNsKyfB/gXmHUQ6OUBnlRTale7X15ZyZeCxTz boffbowsh@Pauls-MacBook-Pro.local',
  }
}
