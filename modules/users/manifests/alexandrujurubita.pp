# Creates the user alexandrujurubita
class users::alexandrujurubita {
  govuk_user { 'alexandrujurubita':
    ensure   => absent,
    fullname => 'Alexandru Jurubita',
    email    => 'alexandru.jurubita@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjYNlgqg/+PiRjbRMg7CrIx4W3Zbm4jLlXfCSN/7KY6jJNF6kmFkDF2tM4T9V+wgwbE5Z95s4m+plH6tfXvYxNde5dk9WuYhJMpSL5DsbcnoEaQsF50CsYOPRiJl4SZTQud1Fi8pOyPtYP9X1f48jKOLuWjTUlb0IyobSdLjPk8B+Qnbzt6NvIOkVL7ot/BzSpvZU/L2ZEFgqNgMPY3l4MCboamb4X340SJj92B5hrH6GGJpmIKizV/nIfGZl40cAZRnBnCJgjXdWILbbRNZp0BCRtsiiMZrZmi1tpnxEOoPIAKo8nwHDd6c+Gnk6nmoE8ipwLolRJeCndZeyt7jxnP5GyqKTz1uAMJMQFBiqFh7ahcIKr4kAsVLnLpx4MugDOgLpOrRtuMuPSaSyuvhWaPmvoU0dbabErXovbji/04OgwvNJwF1sm1A6U/bvXwPWE+gHKDwgeDq1WjXw//1kX+s+AanZNRE2l5xin+SvBzU3+aZVVzaZnk/mCMdXFI0l3UrsxmEowh++8IKSNuxWjhM8HKE68YdrBQAH/Wp+oV79WVnt/A1bwHUklrTDKyemju3cu00tEyQGTzAL2AjLbapQKVODstcDaU9mCmctrc5Mx65xU6gAwF9eSmSUgU3574nJ/4v59KYPmv56Q5cAU5eISsYG+2gnSi+GxfTrmwQ== alexandru.jurubita@digital.cabinet-office.gov.uk',
  }
}
