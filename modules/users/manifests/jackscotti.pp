# Creates the jackscotti user
class users::jackscotti {
  govuk_user { 'jackscotti':
    fullname => 'Jacopo Scotti',
    email    => 'jack.scotti@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsF0hFUtq/NcUDnTmY+cpVbmpnby3dhWVl/hbiwVmEcnsDcSOGS6um5j6E/mNQXXwbqmorlMM9SZ/DKauMJftHTMI1463Iy+za5uc35byYhuFohdUN/Yp0mJc0bSJU+CBkNJMoUSdHBJt9D1OTg9Y6HjLPy+/o2D8JsrjN2mWcDP0KT6KTSSTodqw/eKSsN8eUfjLGruvyDaIfFPGoKKxQiSTwhXU3rkDtpN36txsDLsRAzdRPhddwVcxjZmP88JSJB96WOsozuBY8VsnfvKiTiZoiQiDGpSeVhpG8u8usGuHjDGFiFckNLh/Uk6N9G1YFbJnKygEt5PhegpUrfKbBW1O6aBFTn4Q4AlzIwlGyTverzZ3otBJE9HoIRjbjYcQDl6TSDpClpprBUsv5KxtnDPZHnymoaxBzgVUWVT0mu1mMNiRbETM4xlSHDyAPiEBwO1jax1tkYTRWUXN8ewuynsvsNoafRi1Bc42z3CLwMMSiKej/XPIvUiIDAAnIgoIea3tP8+iYtRM+PwHOsHnGuDr3vl1Z6nOrrtuDMBNpNX5JpPuPwn2T+n3hFZrfC1PQGCo2b+YYRDZvN1Rv2ucamcIw5Q1qIZ6yBE5Zce6OmfC8owfK0QDmxiX5yRNuauc/YS0MsGV3VlKCxkvVBtm7SdZGU6I6homWcWbzRuinrw== jacopojackscotti@gmail.com',
  }
}
