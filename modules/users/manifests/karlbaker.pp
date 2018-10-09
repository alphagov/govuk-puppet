# Creates the user scheme for Karl Baker
class users::karlbaker {
  govuk_user { 'karlbaker':
    fullname => 'Karl Baker',
    email    => 'karl.baker@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCo6AI0U+VFs2dkrwNDMKcU7j5lhSPFDuboQrsGyC1tv8aUBlCSfVDaPRPT20lYANN7tFgQD9mKXaMlUd9bCJJFs7L3CbE+/kSQCE85rfPFDaTMb3/WzYzwMjDD05pRtvdBwmkS6o8IFA4Yyd29qahYhnrO3jexBIZnNdM4nWZCac+nX/8bWckPOGWIR7fTNWoS8C8tioiUDqa/ZflzGqA0NKv7M0I1kwKqHt25FHaqZxnGmnKEC9QIUGbS4cC1cJQ2AO3NqJGPWhb39QrZwvv+Juh9rU3vuohDfx7Xm1Lh8NMVf3+c1vNTcK+DvaGGLZJ20JUBXlRRFFviLo9eaaf5fHIn5bM9aKFwxoPZtlj73FQpv04bUJf/LlbnGgLeW+B6Pl2w2qFp3u5p5NtvPEnLLPm4ljiPsJwl6vdmZy/xLc8/Ze0xyOeMaENm9MFK8BykgBqXqmEsSntvryP2fp1LgwDOt9ufLpF+yLq6hXl/JKYDJZiCTUjpwSbO/GRbsf2PCjzcwLxKIru3QtR9IZmiopeYRbDvH6Zofs/4M4mQVlBv15CKthVSTwwvcb9vOQyRa2uRW6FkY//g04+2yXpU742Cuh0CgNUd1fJ/vO3kCO0Fup/m3M0B7Vsr4NE5/0XdZSXOd5sF9oB4uVh9vE7apD0+hGbeQHzXz5cRNn52KQ== karl.alec.baker@gmail.com',
  }
}
