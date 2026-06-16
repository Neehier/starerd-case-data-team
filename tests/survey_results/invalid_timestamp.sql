{{ config(severity='warn', store_failures=true) }}

SELECT *
FROM {{ source('raw', 'survey_results') }}
WHERE TRY_CAST("timestamp" AS TIMESTAMP) IS NULL
