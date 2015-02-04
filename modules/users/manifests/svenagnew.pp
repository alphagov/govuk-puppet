# Creates the svenagnew user
class users::svenagnew {
  govuk::user { 'svenagnew':
    fullname => 'Sven Agnew',
    email    => 'sven.agnew@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAsJSZcrC7KEPf7J71f924xSBXWGaf23PX04AyzXStyUBmp6tvnFm0TC1ifPg5WdXXFczirK+jvuOj0v/WqvjKbJExGI3iW8yUyhV9gzHR1eUfqQRrFq/19OSv1v+2rdJtW9q/mTfNwUyvvSXySb5cQ8fL5NYfdqBedsD4xyErEkA3dMGS/np1WqnsPT4lf14cbIz8DMdMb2YjyWKzN0z+CgA7d72JBxhGkdA/Bs7SL2+dLVanMguoLzUusNjciVSJsDH7rXWe4er+O9Trbcah7+HRHTD1pI2luoNdtjiM46z7SrWo3NIf3KE6WgNXqgasFP159A1b2zR7XJOkbVDHeOaY1Fk6Xq6/DWlF0tDnMrxVUxg2ATvmbZGZ/s0VmLZvZQSC+gysFR96VscTakngGAJcs9EmPuEblja8OxID2UEuREVesbWw5le53HAjNvwtn1dvapINKLeTlXuVWiCfNb4klBDUf2+rpstTJ0lsK1sCYwn265MbWjR3mjoT8j00bQd+BcurAbmFoeABHgxT8QiLl61L62PU5nq8xO6URezWuJvqiwQT4xuMpCI6J4FIqwduXLfoP1OYz6TBHKnlwrHH7OvlrdavaGKjjZT9+hSmtI5Y9PPV/ZOEPmwr6ebVSQc1pyY8lRXmQJUbw8R+fUAddYQr+mbfOvJz8XuaFv0= sven@ideamachine.co.za'
  }
}
