# Creates the carolinegreen user
class users::carolinegreen {
  govuk_user { 'carolinegreen':
    fullname => 'Caroline Green',
    email    => 'caroline.green@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOBmeAToj9mBQbv8wtLlSJttookVc3eHHLxLqFSTyYKICCM+LuRzQ333/gf3BGPv6L4kf8BYtoZstH/n0qWNOCKwLMd7aWxDt1LJco/5fkN1A5+2de6fnWU4OX4jBEekA41WvOOGkobGU9JTdprmZSVhfbqJ6r6O52zbDaIvOQa+UrSLKIpJb2qEwt3hmksp8rZpq4lwMhnlo1h7lWKZL45v1A8KQ7R84/xiE1Y+lGpvCyS1IBuFPFSkypUJ/QQg0xypM3sP9um0yAjfngfUi39KpoGTqZCJ0PpTcVs+pxKk7qrw06unG0Ip8JKW8maFVzMGGs7bxabVQJVk5Y7gFznYoegMPG0cYvvC+rOVvIZWdMFsfL704GzJ5I82klHuJ2OVcrDIjNuGZCKbMYRvkQE2nn0Z6/pZnqK3g2kIveO0rsyVsWVhN+xo02lpbbQ7Mq+u0VBiJJ9sS2InBTAQf1RUnQtbMF0FNqy4tOqZ2Z6e7bMBnFhX7RanEaI1TQLSOA0C9IlHU79Lwm/5AinKSjkGT7AMqlN+KO3/XMoeAYJEHk/0bFgKZpoLL7PCAHUQ+zNEPlmu+BRwkHHKV0AnmN79bMlQUa/YB7skVqd4AEnhPrKjHTt/SiTHrQZwuQaicYB6Ws3O+hMShCyWAgqt+CqNB7yTZnb2BFCM0Gd1Y8lw== caroline.green@digital.cabinet-office.gov.uk',
  }
}
