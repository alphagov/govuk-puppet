# Creates the tomridd user
class users::tomridd {
  govuk_user { 'tomridd':
    fullname => 'Tom Ridd',
    email    => 'tom.ridd@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBVHhriK603/OpCL1S98q+zwXwd82frLe+Vhh81r0GZSeX7vaaY5nMguVUchpYnybUzaQrHyyfMmKYe3B75pFvmVG+dD+2krYvbO3F07aXZ/vhLvsoypP4yoBvdnNOdkoOW6RADcgkwF1tZ+hjptCzATxR+se5hI2YnCVpHwfh8tOGeOEtx+/Q19nuKZhwdi+0jRiJr54ecQ2sliEbx6qUr6LJRSSkJwsf2CSxOW/5rJ4xGAgDHCa2LnMhiir9v76RiS0Wrjg075bFj+eE8nJ8lDJNNg85/mOfMkiew+AaTX6680TxOJA20uxHiBaXOVPWjiUW+iLkyHGGdM+FMw6QfZQONo1UJzrCR0HeTwKzvwL5h0khTL3L8DO9C5BfTF92q/CISBSm4fKz4HrGskqlGrrnow2Zzf47Di67zIZOq7f34mRmDJsQxQKXNti7Xm9l6DF0ME9W/abgVdbNfGpyWho8bvjd17XWu4XmoBCn0mPyM5pqK9rB1iHAbM/WUavt6cvCRubD93lGGUS3ASz/FoD14Ldg22uIl8eFdwK6IFGgY8kEDh5cJQoPmPIGtmPyqzG48kYDFIOp3l5/V+f1Q7AesEPC9qtt8AbuJqCerFQ6nVz5bnZeGnZ0FKxiwVgg32dtP3kqZxTFn2RPlq2vHaZG3i7yMAsG/F0M08lxpw== tom.ridd@methods.co.uk',
  }

}
