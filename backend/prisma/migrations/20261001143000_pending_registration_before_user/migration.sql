-- Registrations remain temporary until the email code is verified.
CREATE TABLE "pending_registrations" (
    "id" UUID NOT NULL,
    "email" VARCHAR(254) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "display_name" VARCHAR(80) NOT NULL,
    "code_hash" CHAR(64) NOT NULL,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "pending_registrations_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "pending_registrations_email_key"
ON "pending_registrations"("email");

CREATE INDEX "pending_registrations_expires_at_idx"
ON "pending_registrations"("expires_at");

-- Preserve any registration that was waiting for verification under the old model.
-- A missing challenge becomes expired and must use the resend endpoint.
INSERT INTO "pending_registrations" (
    "id",
    "email",
    "password_hash",
    "display_name",
    "code_hash",
    "expires_at",
    "attempts",
    "created_at",
    "updated_at"
)
SELECT
    u."id",
    u."email",
    u."password_hash",
    u."display_name",
    COALESCE(v."code_hash", repeat('0', 64)),
    COALESCE(v."expires_at", CURRENT_TIMESTAMP),
    COALESCE(v."attempts", 0),
    u."created_at",
    CURRENT_TIMESTAMP
FROM "users" u
LEFT JOIN LATERAL (
    SELECT ev."code_hash", ev."expires_at", ev."attempts"
    FROM "email_verifications" ev
    WHERE ev."user_id" = u."id" AND ev."consumed_at" IS NULL
    ORDER BY ev."created_at" DESC
    LIMIT 1
) v ON TRUE
WHERE u."password_hash" IS NOT NULL
  AND u."email_verified_at" IS NULL
ON CONFLICT ("email") DO UPDATE SET
    "password_hash" = EXCLUDED."password_hash",
    "display_name" = EXCLUDED."display_name",
    "code_hash" = EXCLUDED."code_hash",
    "expires_at" = EXCLUDED."expires_at",
    "attempts" = EXCLUDED."attempts",
    "updated_at" = CURRENT_TIMESTAMP;

-- Removing these old unverified user rows also removes their sessions and challenges.
DELETE FROM "users"
WHERE "password_hash" IS NOT NULL
  AND "email_verified_at" IS NULL;

DROP TABLE "email_verifications";
