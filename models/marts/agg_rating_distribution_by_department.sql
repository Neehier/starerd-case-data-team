SELECT
    department,
    rating,
    COUNT(*) AS rating_count
FROM {{ ref('fct_survey_feedback') }}
WHERE department IS NOT NULL
GROUP BY department, rating
ORDER BY department, rating
