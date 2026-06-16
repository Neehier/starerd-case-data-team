WITH survey AS (
    SELECT * FROM {{ ref('stg_survey_results') }}
),

users AS (
    SELECT * FROM {{ ref('stg_user_metadata') }}
)

SELECT
    survey.submission_id,
    survey.submitted_at,
    survey.user_email,
    survey.rating,
    survey.comment_text,
    survey.region,
    users.department,
    users.country,
    CASE
        WHEN survey.rating >= 4 THEN 'positive'
        WHEN survey.rating = 3 THEN 'neutral'
        ELSE 'negative'
    END AS rating_bucket
FROM survey
LEFT JOIN users
    ON survey.user_email = users.user_email
