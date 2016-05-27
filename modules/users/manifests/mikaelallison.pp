# Creates the mikaelallison user
class users::mikaelallison {
  govuk_user { 'mikaelallison':
    fullname => 'Mikael Allison',
    email    => 'mikael.allison@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCb6Tz5ZaPAph0TT7Jh1CIQ+iTYuS/TxeMVqj3+DeEYORRbGBAG12lX1Ma95q+M+iuFj7m3bbYiMDtSzflIKhqN1ymlv/A2xyCqsiNSGx0Zl978Q85oSzzeh0//nzet+pn0QxEpb1d2e7gcHT1hakp802PuPVSMZycQqZa2VvNKC+OEEpPJKJ98U1XxYR4vR9hCqXhnq7uwLWr5QNUxSlsrZd60RawRitOBqSU6bMZCGKjA+HTz3agmcVa5C9cISAxx34NP7UHDEyEp6825y+IJtcXigIDutzR7kzBkoXLz8IV1ccgpLCjTQyRQjtV4q51oifs0NkIey84yykdUAshyY4g8YG+hv2NU1rLBTtG5MM4yYAdMAiNRz6dW+C+3zM5fZvOmk/MW6lcFIX9mRr0MSp7Z0sd0inVyj5nkug2NVsGrTK8Hsgm3jIHw0nFRBDuVd1jybLuy6a/yf7epfMz6Idhh7JDeu+96u9j7Yhux0q7a4R2Y1O5xGpUthUJmgzr4mJ8UfxQgCWBP+u+ZWUjV3eGK+JfbXCWwSGdGwugVjxfJB/VGbUVr5vBThyuDXh4OQp4GkOUAl1810BbsTltF+ly0W+fYK5npWnu8EsavLqzsIiXcd4YIoQ2hYa7/xMcgwTu26K7C8svKcYvsapD3ZMGvNHlhHgcjhuu32Kb4Gw== mikaela@MacBook-Pro.local',
  }
}
