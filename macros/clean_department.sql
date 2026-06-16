{% macro clean_department(column_name) %}
    LOWER(TRIM({{ column_name }}))
{% endmacro %}
