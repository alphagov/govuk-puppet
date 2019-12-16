# Create the brucebolt user
class users::brucebolt {
  govuk_user { 'brucebolt':
    fullname => 'Bruce Bolt',
    email    => 'bruce.bolt@digital.cabinet-office.gov.uk',
    ssh_key  => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDl0ukq+NcniRU5w67D/ZF0V23MH0G1I5pab/tkUctmyTQDll/rnOuqyeX+A/fJZoxqT69Ceg9Mw9+4+Zg8t9fvwQhlp7/fgU2br+IZShc3BWpXat73ZlU9JT8kS1A4FJI/kYTJJ3zEkF9TXoS5zLTIbyma5ocryZSNqQY2iXLzfQJywUzHxEDgKJOYe/1/RWRMpmB2x20DHdDH2mjzsKiEWaIEtvUNj/ivSSfLVtUsTpGyV7fP4KD13rn330O2Ttv1EuvsmfL+VzBVUog2oBpPG9YLzZEkZ2xKhm3nHAhIusWmALhprCFEcuN0mwTE8e9iWUahJDpeeSVGyaHYzLoTT/PKf4aOMlTrSIW/p2s3JtrqNRdMxjT+GFeChMKaxms1XKFwn/NTBtYU4PiDlRpFZL4Kc8kbglN07rroiY7RbGaQsL9VkMILO9rg1w9feiRWXDhlEvdTjy8FX7inR4hlwIV+sHlPcq5DG1wOlWSxpgy7R5w9fPDN6CTQ+YnWJvqqgv8ZZor0AZp+hE1geCwqyek6uEv9dEsenBpZNmu+hbrQKFcSLsu+Nt9aqhT0evae3uWTTGBKW7js9HVL8R4w8IK867BkxMZjuFXUl/IowchX3iXBxtkrkm4H2IavY5yy1qw27WjZwEvwda2HEPhCo7ky0US8J/QH6XmS9NzGQw== cardno:000610162313',
    ],
  }
}
