WITH source AS (
    SELECT * FROM {{ source('raw', 'survey_results') }}
),

deduped AS (
    SELECT DISTINCT * FROM source
),

cleaned AS (
    SELECT
        submission_id,
        {{ clean_email('user_email') }}             AS user_email,
        TRY_CAST(rating AS INTEGER)                 AS rating,
        TRY_CAST("timestamp" AS TIMESTAMP)          AS "timestamp",
        comment_text                                AS comment_text,
        region                                      AS region
    FROM deduped
)

SELECT *
FROM cleaned
WHERE user_email IS NOT NULL
  AND rating BETWEEN 1 AND 5
  AND "timestamp" IS NOT NULL
