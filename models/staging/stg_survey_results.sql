WITH source AS (
    SELECT * FROM {{ source('raw', 'survey_results') }}
),

deduped AS (
    SELECT DISTINCT * FROM source
),

cleaned AS (
    SELECT
        submission_id,
        {{ clean_email('user_email') }} AS user_email,
        TRY_CAST(rating AS INTEGER) AS rating,
        TRY_CAST(timestamp AS TIMESTAMP) AS submitted_at,
        comment_text,
        region
    FROM deduped
)

SELECT *
FROM cleaned
WHERE
    user_email IS NOT NULL
    AND rating BETWEEN 1 AND 5
    AND submitted_at IS NOT NULL
