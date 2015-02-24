# Creates the benjanecke user
class users::benjanecke {
  govuk::user { 'benjanecke':
    fullname => 'Ben Janecke',
    email    => 'ben.janecke@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYT3RIKlziKqYhnoYTfQU83waNI8L9qzWrgGvpI5uOUGGk+UbwNTx62HbEKGHXAx6wDMjXRBrO01sMkjIhLP3SnFBJVSqAWPhxJxGiaXf9qm5tpxREYSS2AyXDin1cRcIOW1Y+6pfkEsCJ5mK/s5TCyYe/07MhwsGpeQpGEAr0zh4wpqKPmEycfxIqfiaJIOacKLjKZL9jqaqSRf830Kw2Ha0ljXcZLiEKfPB5F0SQyz3N4kGPdHTScZksqJmmQOtF7vy8rO1L4tzoxwXnt7Tk4K9pw1TnUYND3dMbEaONM72S5WRd8bvQdacVNhiJaBLBpSwDt7me2MTSwXkwSxDp benjanecke@gmail.com',
  }
}