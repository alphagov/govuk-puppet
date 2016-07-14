# Creates the andrewgarner user
class users::andrewgarner {
  govuk_user { 'andrewgarner':
    fullname => 'Andrew Garner',
    email    => 'andrew.garner@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChK6SBtnmisDZm8D6R5UyJJ4gOxr8jyWg+Dg67P7DrWKJbmR7mp3E8RG4cyJZULz3ftM3M9PXXpmyDfaXWbSzcvVct2ZihIyCIT7P/tUPlQ9jRj+nxeWKy/UqM8vwxbnLQJvDKozYkimyck/+AtpJ8JUdOGuzctTuFRkWb7GWhXnui7DvPmWHl6eQZEN1mHuNZw3lRAdRwm/ZKBpUxQq3/NvNSpaFYNCn/MrwC/qVQGzRpGTCJmjwZNQhCVl91BaxWROizxzbGHOnKu6XHeRolNdOii87MZ7SHREbdtAwHcax9QXhF3eDMT2Z2Iz/ZokZus+cuoVqo4LFBjTAccYaIW3+Eb0OeUL+a8XhlgwtzM7v4/DCnmA+2VSaYNfEX3pl4GmaPGNNNwm/QIFsAcbmmy+VdQIzzd0QZO2ViwopO8/7UfVsKXvoPRhFcZz8MeLZ3yWCMwyxxlFpiAil0oPgLTznlroMSa9d6UkafJEE00yaIm2nNo/O8IjjoD85Crax6X4KIohQ+nvJwsghci8UgJ+l7tuaYeQX/kDtjCkGNFgQcRZGE8Iy857Q/N8kyojRj0aUGX4C7oXeKIybLID9wnnOOQvtpSiXlv29/6318/93BRApa54E+mkVRoWzJRoIe+pM3T6Q6ZS8LlktlzjHWyqpRbdKHxg5DCt81r0DUhw== andrew.garner@digital.cabinet-office.gov.uk',
  }
}
