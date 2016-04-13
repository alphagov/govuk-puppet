# Creates the tomhipkin user
class users::tomhipkin {
  govuk_user { 'tomhipkin':
      fullname => 'Tom Hipkin',
      email    => 'tomhipkin@gmail.com',
      ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvAK56Pn2Ml6KBJOlXZ7VTZ9PuNOXwgu1lMa46bSWve//tfojAJEL7jx+b4In7Znr//AXz1UZQovFOvns1HrKoA+p6YlyVKXb+7qwcHpt2exHUV00jWBUuVeFqt+CRDIiXnTc0P3Udzy4RDo9c1DoN2O61eerZhdfACAEu/i+2e+GBdGnK3ANL9xdoQPfhlz9cRIfCksBvgDGHkbZa+25nxQz9MLLep9unbPbAjYU9bsWX6ARh4qfq6R9hO7ZeXxC0FbfK7jaSpEDsj/HLOV6iurWFvUXQbqLoft7tGqMU3TnEbVzkXpSS8t1jNOWAtkaKnkga2uPkSBBGR++M3QnH dxw',
    }
}
