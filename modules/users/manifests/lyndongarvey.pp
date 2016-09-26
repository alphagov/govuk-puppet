# Create the lyndongarvey user
class users::lyndongarvey {
  govuk_user { 'lyndongarvey':
    fullname => 'Lyndon Garvey',
    email    => 'lyndon.garvey@digital.justice.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCk5ukIlazRq0DS2GZe/36R1oPWWSXQvga7IJHt2drJ9rlwRLHVxr0jVjtJuoNRcCATrqWWHjtcF9uL/ZGsm34Zufe8WW4m1hgf2zB5tvY3KdhPTJhz+bq2mTI1RaZN+4l0grRhBQH5shpdMuORh1MNG1zq56ffn178XzALSmUko0HhMwDyhR0xKGIVDR/29YZTrj1h4b+49JpwptON2lCc4vq86JrjyKV/MhWIqBAyrMfCD5/nEzHmaRWuu10sEg2Zu+tPrlw7yuLEypMIvsBcDiLFjNsYEDshtPlnF9zj0GWLk7wz8mxkc24PIxqw/umWzLdsdAe5sAhc8/JJd/3r5yPIakizknk5+c+Ne9mY1RgSjGR9Y1wTGJKis6XCGI5bUPzuv4JmJiBeLqUXOhLGkHGMF3YtEEncR5Y4+51vIlUk5b8hET4ruzaPgVJ5xiZcoLrYtEWJ3pxeSjylEeHfl9RxFLOZjmVYzwgIWLRspr0VSkSjUt4qzTk0C/pfxyZ61cmEKwCdIieHEzsdYJ5WU0YFh7+z8eUMLKYAdQAxnGitGx5myaA5QCaiYEw7nUfpX9FcQuZ9f52gB4sX4uMJ7e6VaQCWccsrj9NMhH6dtA5pwDFoSG+BsL++2Rcnwc02i2BZjhM9R3bkl33JECnK1IzkAvholvtccLWYOf0slQ== lyndongarvey@Admins-MacBook-Pro-9.local',
    ],
  }
}
