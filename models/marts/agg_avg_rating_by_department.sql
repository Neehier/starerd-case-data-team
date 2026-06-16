SELECT
    department,
    ROUND(AVG(rating), 2) AS avg_rating
FROM {{ ref('fct_survey_feedback') }}
WHERE department IS NOT NULL
GROUP BY department
ORDER BY avg_rating DESC
