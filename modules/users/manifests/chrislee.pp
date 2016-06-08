# Creates the chrislee user
class users::chrislee {
  govuk_user { 'chrislee':
    fullname => 'Chris Lee',
    email    => 'chris.lee@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgfLFBK39O2zPPXDzxJC6yYtM1hKJV1Vau7CVVWprQZLt6TDYUVJlpZHEJeAe9LDeNcG9K0LKe8Tz5Q93DkKJHSJjs/aR3v7SZpSjPUIWKzDmeLG5KsWC+eZJaGYvWrHODdgTttbg9RlBADzVkzOoSrRL347SGU04755IgjSbLxb0cFNjm5IhV3EbMiIxKa5tSlVZZ9yxytxRwsOwuka7vGjmoHbSr6hYYtMNpj+Q0C8aPPEdw6twLzjQERbzmA6IxCrSKPZH0XSeyZI5ooJOmxVZKTn9jhruWUhX2yNXBtGBEmhJ1AmGddI5w+ML0tZNnSIR93i80afuSA30BKHU+oakK7YYH55XAd//wjJZTkOEuaGCOkt/+xQ8RkCwgOEdhj1Ohhs36d8FWIEHYC53fpZ4Uvk6tHJ3zeHESQ9aHq8YRGBOaxL4OY+5Ce4CNDxTzUUXkhYLeC+X7ypgTdBALBKJHl4pLm6K7HjirxLsz2J2EDrqFAFuIItK9qaW3R+QZssuwp/lB/Kp6ory/s3slFyi7cqyRzibarrFxizRaMoYpdXhNjWZoObQsdvba8xS4IElunOQJJbMVDVo1sVqLziznhe4ZMYQLdFuGwNuCGjKz3gT5xeYq4eIAcZNvb3YLh2Kant07QxqcHKF08WuGuD2mf/+vZPWNqgomtvekuw== chris.lee@digital.cabinet-office.co.uk',
  }
}
