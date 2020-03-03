-- This script is sourced from
-- https://github.com/alphagov/content-publisher/blob/master/db/scrub_access_limited.sql
-- Any changes should be made their first and then copied here.

-- Remove current status of any access limited editions
UPDATE editions
SET current = false
WHERE access_limit_id IS NOT NULL;

-- Set the live editions to current for any docs with an access limited draft
UPDATE editions
SET current = true
WHERE live = true
AND document_id IN (
  SELECT document_id
  FROM editions
  WHERE access_limit_id IS NOT NULL
);

-- Delete any access limited editions
DELETE FROM editions WHERE access_limit_id IS NOT NULL;

-- Delete orphaned revisions
DELETE FROM revisions WHERE NOT EXISTS (
  SELECT 1
  FROM editions_revisions
  WHERE editions_revisions.revision_id = revisions.id
);

DELETE FROM content_revisions WHERE NOT EXISTS (
  SELECT 1
  FROM revisions
  WHERE revisions.content_revision_id = content_revisions.id
);

DELETE FROM tags_revisions WHERE NOT EXISTS (
  SELECT 1
  FROM revisions
  WHERE revisions.tags_revision_id = tags_revisions.id
);

DELETE FROM metadata_revisions WHERE NOT EXISTS (
  SELECT 1
  FROM revisions
  WHERE revisions.metadata_revision_id = metadata_revisions.id
);

DELETE FROM image_revisions WHERE NOT EXISTS (
  SELECT 1
  FROM revisions_image_revisions
  WHERE revisions_image_revisions.image_revision_id = image_revisions.id
);

DELETE FROM image_blob_revisions WHERE NOT EXISTS (
  SELECT 1
  FROM image_revisions
  WHERE image_revisions.blob_revision_id = image_blob_revisions.id
);

DELETE FROM image_metadata_revisions WHERE NOT EXISTS (
  SELECT 1
  FROM image_revisions
  WHERE image_revisions.metadata_revision_id = image_metadata_revisions.id
);

DELETE FROM file_attachment_revisions WHERE NOT EXISTS (
  SELECT 1
  FROM revisions_file_attachment_revisions
  WHERE revisions_file_attachment_revisions.file_attachment_revision_id = file_attachment_revisions.id
);

DELETE FROM file_attachment_blob_revisions WHERE NOT EXISTS (
  SELECT 1
  FROM file_attachment_revisions
  WHERE file_attachment_revisions.blob_revision_id = file_attachment_blob_revisions.id
);

DELETE FROM file_attachment_metadata_revisions WHERE NOT EXISTS (
  SELECT 1
  FROM file_attachment_revisions
  WHERE file_attachment_revisions.metadata_revision_id = file_attachment_metadata_revisions.id
);

DELETE FROM active_storage_blobs WHERE NOT EXISTS (
  SELECT 1
  FROM image_blob_revisions
  WHERE image_blob_revisions.blob_id = active_storage_blobs.id
) AND NOT EXISTS (
  SELECT 1
  FROM file_attachment_blob_revisions
  WHERE file_attachment_blob_revisions.blob_id = active_storage_blobs.id
);
