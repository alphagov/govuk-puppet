# Creates the christophwong user
class users::christophwong {
  govuk::user { 'christophwong':
    fullname => 'Christoph Wong',
    email    => 'christoph.wong@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7OxkorP9m1mIpbJmDDyBrv7EKVquiRbEqLUrIXFNiiO3C1d4aIyUDzFDFiXoN7T0RbfzmUBSLAN4g9HypdEalwj/Low0/tJ20snxcOPrntcEjRMiXnLNCNZkv59Rc0Q2wEfjHa6Co+L+xmbh2AarkItyRA+osnPw0T+No4CKGt6lv9+MWqt/gmji8LMZaxuNlUKxZH0c2yc4cSonyRgORwP3g7U5fF+g3w58gVyFwneE7gJEVMTzrcsF8qxQuFLvV7H+1W9ZkJwdhFadmoutcrSJagXQwfqE9DRQvvbxPZDGssueH1xtwTF4jth1YKSbrOkNk9n9DfSN3LQ6NALg1+4q4KfsXS2MXCLEkdwi/M6W42thmmOctFHoweyTsMzQuMwVqCm+WSPx/b7+dnWAHQz3ZSJmVQ3VlFU9NbV7D2fHUPBPCYkkrRN/mYVWNjDBQmWscY5WCaIbzqfFD/BTTaSY+9CU1mXws4jAOewDBM12i165mrB9Sk1IShUASX955IA7XACSoig9Z2bNvY9hnPocsZYtP89gLJ3hbwmtLfVjg06okSRgpQvnXACfDgem/LNabo38uDYcHofEdS4Tfm+W9I4jyPSDSv1IK4SNDvp/qxA18AxhKVd7XvXKuTdlrdNl3CEgXcavtLiMiQJJzbsKpUOOHV7+fKYKb7NRRpw== christophwong@thoughtworks.com',
  }
}
