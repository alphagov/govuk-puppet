class users::groups::ertp {

  govuk::user { 'jameshu':
    fullname => 'James Hughes',
    email    => 'j.hughes@kainos.com',
    ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDEQqW37SgmaHq7C0yT1QnDL6km/ibHiqwyWe7f8oq85P5gyYk1q1NKSiocYrhBzfHa22BdpBxZ7hxRZXFdVCfEt87XMjIK29G1atSDLRDp4fmwlLZqFWCSxqsVihvUBjxKpXUm8lXonlwtCn9vZ7EEcJlY2VdRaNxXTHzy/XedvUbSYurLGfKZ3N9EX+iuLrdj2WlcYp7V3yx6eTFITqOnkY8K6kZ2V6zRruxMITaho5U61w+FQcK4aDXimbck0jBpvaHCpjjIWqaZ0Z0YB7PuyLWIygHoqshNfEV9PpEL4SwEOOlIqbPtb1MzvRPXSxHQjvd39XbJJQO/L86Odz2T',
  }
  govuk::user { 'michaela':
    fullname => 'Michael Allen',
    email    => 'm.allen@kainos.com',
  }
  govuk::user { 'leszekg':
    fullname => 'Leszek Gonczar',
    email    => 'l.gonczar@kainos.com',
  }

}
