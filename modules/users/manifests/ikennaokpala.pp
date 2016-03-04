# Creates the ikennaokpala user
class users::ikennaokpala {
  govuk_user { 'ikennaokpala':
    fullname => 'Ikenna Okpala',
    email    => 'ikenna.okpala@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdkB79xv2FayQTTBUGi60VFVJa9q+tJLRkh3ECbYcHP8q+I+ID63Khr5yDfkvArtqoSh9+qQW30ve0IB9SvW8GXria5JC1jN05Xb+VgQXQHmAIz0V6cSiBikfMGo8HKpxIPpqK+I8RZAtfi18uwsSS+IDDBfzdT93CKCIPcllRs938GrzGLkY8aXX5PvVQ1O7rP2bNVlnfbSSlowtBcE6fPpU0lT5kL28XnZ3ImnYNEgr3/sQPoQi3XtCH9/SalPrniF5jqCqntnk7G/gs1mtEweSse2BBcMofQQJoLo4AlYFdE4xOv4pyS22J3/8HPvdlnsKDYAjrNw7njqwEUKzb ikenna.okpala@digital.cabinet-office.gov.uk',
  }
}
