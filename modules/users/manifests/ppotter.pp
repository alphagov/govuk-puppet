# Creates the ppotter user
class users::ppotter {
  govuk::user { 'ppotter':
    fullname => 'Philip Potter',
    email    => 'philip.potter@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsYvhPkvKma2RwWVwUNJ2fcoNjlObibUka0fl5WcctTokz8RISDkOAPjz+L0QmGsq/Dhgn/mbspKFyNKvQsujeooEpaO+cjYPXoUF1NTxhbUrMEu2uE+CPoj4zPbAZ9A6LdxkL13F3gJwZi9k8K9+6AnJeB4IrCLS5KHRiL+tBZMLPvKnn54M6PCfkWJH6zVO92plFTpRX1W4GanUwYGTemFX0qUwFgZu9OJvGiR+ZQKJMQ2Y3O+IMHv1KusfBrO+Q4iWn+A5VcJRoxml3lr0fYlbaetCpszkaY5HbQsLPDGtvsN1jXj2ghVe2ZbK8SKe13g+LSqYxmIX5qCAoEi+J',
  }
}
