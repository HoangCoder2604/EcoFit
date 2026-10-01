-- Accounts created before email verification existed remain usable.
-- Only registrations created after this migration require the one-time code flow.
UPDATE "users"
SET "email_verified_at" = CURRENT_TIMESTAMP
WHERE "password_hash" IS NOT NULL
  AND "email_verified_at" IS NULL;
