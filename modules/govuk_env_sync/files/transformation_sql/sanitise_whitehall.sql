-- This is a SQL port of https://github.com/alphagov/whitehall/blob/master/script/scrub-database

SET @lipsum_line = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
SET @lipsum_slug = 'lorem-ipsum-dolor-sit-amet-elit-';
SET @lipsum_body = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget metus leo. Integer ac gravida magna. Vestibulum adipiscing pretium vehicula. Praesent ultrices eros a mi elementum id ultrices ligula ornare. Vivamus mollis, odio id luctus scelerisque, dui nunc semper felis, vitae fermentum tortor ante eget erat. Maecenas eleifend elit nec libero porttitor sodales. Quisque vitae augue ut justo vulputate tincidunt at pellentesque tortor.

In bibendum urna sed sem egestas aliquam tempor leo dictum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec rhoncus adipiscing ultrices. Morbi gravida, lacus vitae adipiscing tincidunt, quam tellus consectetur leo, et posuere tortor metus a nulla. Aliquam erat volutpat. In et ante diam. Nulla laoreet ante ut sem egestas sed placerat elit viverra. Duis tempor congue est, rutrum mattis neque aliquam non. Nunc a massa quis nisl blandit elementum a in elit. Pellentesque sollicitudin, magna nec viverra consectetur, risus ante bibendum diam, vel volutpat risus neque sed risus. Nullam leo enim, faucibus eu consequat facilisis, auctor eget velit. In ultricies lectus in velit commodo tempus. Fusce luctus condimentum mi, eleifend auctor libero volutpat sed. Quisque tempor viverra mauris, non blandit ipsum vulputate viverra. In sed enim nibh, eu auctor urna. Suspendisse potenti.

Proin elementum varius quam, eu fermentum nulla vestibulum sed. Integer urna turpis, malesuada sed vehicula vel, vestibulum gravida purus. Vivamus adipiscing ullamcorper bibendum. Nunc pretium condimentum nisi, sit amet blandit augue accumsan in. Ut in erat urna, eget elementum dui. Nam arcu enim, iaculis at interdum at, viverra non massa. Sed nisl massa, pulvinar in blandit nec, pretium eleifend quam. Nullam a nisi dolor, ornare sagittis felis. Aliquam laoreet sodales leo sit amet rutrum.

Fusce dui ante, ornare a interdum vel, posuere non ipsum. Morbi placerat est ac quam ultrices eget feugiat tortor rhoncus. Duis tempor placerat leo sit amet volutpat. Curabitur dignissim pulvinar sem, non auctor dolor mattis sed. In volutpat volutpat massa quis convallis. In in cursus tortor. Pellentesque massa sem, rhoncus a iaculis ac, tincidunt sit amet nibh.

Etiam eu orci sed massa porttitor volutpat. Maecenas euismod lobortis risus sed vehicula. Proin luctus fringilla odio, in ullamcorper eros suscipit ac. Ut consequat vehicula urna nec posuere. Donec vel dapibus massa. Pellentesque consectetur odio a mauris semper bibendum. In vitae sem sollicitudin est egestas gravida id non urna.';

-- Redact access-limited drafts.
UPDATE edition_translations
SET title = @lipsum_line, summary = @lipsum_line, body = @lipsum_body
WHERE edition_id IN (SELECT id FROM editions WHERE access_limited = 1);

-- Redact slugs for access-limited drafts.
UPDATE documents
SET slug = CONCAT(@lipsum_slug, id)
WHERE id IN (SELECT document_id FROM editions WHERE access_limited = 1);

-- Redact email addresses and comments in fact checks.
UPDATE fact_check_requests
SET email_address = CONCAT('fact-email-', id, '@example.com'), comments = '',
    instructions = '', `key` = CONCAT('redacted-', id);

-- Redact attachment titles for access-limited drafts.
UPDATE attachments
SET title = @lipsum_line
WHERE attachable_type = 'Edition'
    AND attachable_id IN (SELECT id FROM editions WHERE access_limited = 1);

-- Redact HTML attachment data for access-limited drafts.
UPDATE attachments
SET slug = CONCAT(@lipsum_slug, id)
WHERE attachable_type = 'Edition'
    AND attachable_id IN (SELECT id FROM editions WHERE access_limited = 1);

-- Redact file names for attachments on access-limited drafts.
UPDATE attachment_data
SET carrierwave_file = 'redacted.pdf'
WHERE id IN (
    SELECT attachment_data_id FROM attachments WHERE attachments.attachable_type = 'Edition'
    AND attachments.attachable_id IN (SELECT id FROM editions WHERE access_limited = 1));

-- Redact govspeak content data for access-limited editions.
UPDATE govspeak_contents
INNER JOIN attachments ON attachments.id = govspeak_contents.html_attachment_id
INNER JOIN editions ON attachments.attachable_id = editions.id
SET govspeak_contents.body = @lipsum_body,
    govspeak_contents.computed_body_html = NULL,
    govspeak_contents.computed_headers_html = NULL
WHERE attachments.attachable_type = 'EDITION' AND editions.access_limited = 1;
