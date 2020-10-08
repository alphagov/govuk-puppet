
UPDATE users
SET suspended_at = NULL,
    reason_for_suspension = NULL,
    unsuspended_at = NOW()
WHERE email IN (
  'ovas.iqbal@digital.cabinet-office.gov.uk',
  'samuel.pritchard@digital.cabinet-office.gov.uk',
  'tirath.rai@digital.cabinet-office.gov.uk',
  'pentestapiuser@alphagov.co.uk'
);

UPDATE oauth_access_tokens
INNER JOIN users
  ON oauth_access_tokens.resource_owner_id = users.id
SET revoked_at = NULL
WHERE users.email = "pentestapiuser@alphagov.co.uk";
