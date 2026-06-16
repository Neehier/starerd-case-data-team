WITH source AS (
    SELECT * FROM {{ source('raw', 'user_metadata') }}
),

deduped AS (
    SELECT DISTINCT ON (user_email) *
    FROM source
),

cleaned AS (
    SELECT
        {{ clean_email('user_email') }} AS user_email,
        full_name,
        {{ clean_department('department') }} AS department,
        country
    FROM deduped
)

SELECT *
FROM cleaned
WHERE
    user_email IS NOT NULL
    AND country IS NOT NULL
