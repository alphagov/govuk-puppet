-- This SQL file anonymises email addresses in the email-alert-api database.
--
-- It tries to preserve structure so that multiple occurences of the same address
-- are mapped to the same anonymous address.
--
-- It runs when we copy data to Integration via govuk_env_sync:
-- https://docs.publishing.service.gov.uk/manual/govuk-env-sync.html
--
-- Please make changes to this script in
-- https://github.com/alphagov/email-alert-api/blob/master/lib/data_hygiene/anonymise_email_addresses.sql
-- where it is tested. Then copy it to the govuk-puppet repository.

-- Deletes all emails that are older than 1 day old.
DELETE FROM emails
WHERE created_at < current_timestamp - interval '1 day';

-- Create a table to store all email addresses.
CREATE TABLE addresses (id SERIAL, address VARCHAR NOT NULL);

-- Copy all email addresses into the table.
-- Ignore nulled out subscriber addresses.
INSERT INTO addresses (address)
  SELECT address FROM subscribers WHERE address IS NOT NULL
  UNION DISTINCT
  SELECT address FROM emails;

-- Index the table so we can efficiently lookup addresses.
CREATE UNIQUE INDEX addresses_index ON addresses (address);

-- Set subscribers.address from the auto-incremented id in addresses table.
UPDATE subscribers s
SET address = CONCAT('anonymous-', a.id, '@example.com')
FROM addresses a
WHERE a.address = s.address;

-- Set emails.address from the auto-incremented id in addresses table.
UPDATE emails e
SET address = CONCAT('anonymous-', a.id, '@example.com'),
subject = REPLACE(e.subject, e.address, CONCAT('anonymous-', a.id, '@example.com')),
body = REPLACE(e.body, e.address, CONCAT('anonymous-', a.id, '@example.com'))
FROM addresses a
WHERE a.address = e.address;

-- Clean up by deleting the addresses table and its index.
DROP INDEX addresses_index;
DROP TABLE addresses;
