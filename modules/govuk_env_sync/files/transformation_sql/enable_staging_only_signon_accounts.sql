
UPDATE users
SET suspended_at = NULL,
    reason_for_suspension = NULL,
    unsuspended_at = NOW()
WHERE email IN (
  'ovas.iqbal@digital.cabinet-office.gov.uk',
  'samuel.pritchard@digital.cabinet-office.gov.uk',
  'tirath.rai@digital.cabinet-office.gov.uk',
);
