# Creates elliotcm user
class users::elliotcm {
  govuk_user { 'elliotcm':
    ensure   => absent,
    fullname => 'Elliot CM',
    email    => 'elliot.cm@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDuu74o7gyb8Bk/SvHmXKFXvPe8LXj+vtHdg0qnv9WMDcXoZx/LLmd36PS7/r9vRalXjqateLXPIzmjEpgxe01EfsriTOUs/vYIvbyQ7bH/OEdZDC9WqN7aNFLnc5XD7v1MMyf+1TXO74Lu/L+t6TXgnbvF8PIQ19B4lXIjcL8LpYCjyKWSLm2Iv2BQOuZL2S2StCu6Sg6QIxtdiV+b4jhXDSq3RIZIulg5W8o0TPz895lf8qDR4ai7yT3M2b8bBeGLxwPHpGWJXKz2JIDWFV1b75QMYvuUMZyuRfh4L8FvzbvSFq00BW0mZbBCorkXG7wu4AchHhpgkh6DQxuHI/SS8oMYEYvs2gzv8CPegZWEJvkXSIc+aArJEeD/C1xamBb13yQWrbbMfVwzfXLD2uqpV1vJW4tXkxIDDTVKBHoV5CZvrjB2kh5P0+D3DAuBw0aAoBEtbvuJbcViq8GJFsuqqeUt4hzFV+4zlxxzP1Z8Y34cfRv6HaileCjo0UvI/P6I6LXvO1LQvwRUOlub4hCuNtIU5zBZOsuMdwV6+IlyitueD3Bami/bFKn3zbrCzw4J8lyHYNPwz2XlU2XX1Lf3Aq+xOUjBov6ZHrzH+Di5qFOM1+ASLLS6kuKodQycpSoweRB7gt/1QVltwgpV5ooRNQO85VgHd0LFW2yPd/pqUw== elliot.cm@digital.cabinet-office.gov.uk',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAbdI+O/lbiNwGJJTG+6C3tlqYMgo6hxLzsm07I6/Ptu1rSkee/iRUbjRbB7gFQ1L2sOqO05KmxNfnLPKxiUYvrZgcibM24KYtpIFHJVU1wS2utkBkTT+deCErGF02BLS43Km5B48D0YCWkY6GTVRhl6RdXaTVBrJDFxwAJk5P6bKkOCSqb9B/RUCK4UpJROoAZfQXtiJLWxJiDon8PI6+FfYdKdhu7xs00nIHbVxAIvMABeAKtBLO8UxxG9q8AGTHkM75Z/a2/xPb06HuI//HFyyBSU2OaYDrP4cKQj/EFsem8gYEqBwUFfGncULJINb5CellN4YgQvFps0ybOEEL6JAIFivf70GBiL8pjuELYaQPgKynRMzoT9dma615Z7jI+otB6BktVxYldhoK+AEMtoa/vEkEPzimbpJE0t9sqMrB2t78elM5bGolvdi3DGynJCkaTGPGVBrowdYtG4nrIWAAOJPcObqmoKfu4hm8Tgk/yBnqGxJUie67fWB8acl69Qcl64l3BkpqSdE+7bhBXyTIq7EHIBomKf3BLgfBV1ePvZ4M/taXgxuxV77QeBCvvMyBU23S5B4+h7WnAlnbaSME5PLBxgZs3keql+qgL3w4DfG3vHb3wcQFipZYU7YQQ6IUqE+Bt+SS3kab+VUVqr126UIca/4eiGfmLw/NVw== elliot@linux-laptop',
    ],
  }
}
