# Data Engineering Case — Survey Feedback Pipeline

Welcome, and thanks for taking the time to work on this case.

This exercise simulates a simplified version of how we ingest and transform customer feedback data into analytics-ready tables. It’s intentionally scoped so you can complete it in **~2–3 hours**.

You are free to use any tools and stack you prefer:
- Python (Pandas, SQLAlchemy, etc.)
- SQL (Postgres, DuckDB, SQLite, etc.)
- dbt-like models
- Notebooks (Jupyter, VS Code, etc.)
- Or a combination

We’re primarily interested in **how you think** about data engineering: modeling, cleaning, joining, and explaining decisions.


---

## 1. Scenario

You’re a data engineer in an AI/Data team.

The company collects survey feedback from different systems. For this case, you get:

- A file with **survey responses**
- A file with **user metadata**

Your job is to turn these into:

1. Clean, well-structured staging tables  
2. A unified “analytics-ready” fact table  
3. A few simple aggregations for analysis  
4. A short description of your design and reasoning  

We’ll review both your **code** and your **explanations**, and we’ll discuss your solution in a follow-up conversation.


---

## 2. Provided Files

All input data is under the `data/` folder:

- `data/survey_results.csv`
- `data/user_metadata.csv`


### 2.1 `survey_results.csv` — Schema

Each row is a single survey response.

| Column        | Type    | Description                                                       |
|--------------|---------|-------------------------------------------------------------------|
| `submission_id` | string | Unique identifier for the survey submission (UUID).              |
| `timestamp`     | string | ISO 8601 timestamp when the response was submitted.              |
| `user_email`    | string | Email of the respondent.                                         |
| `rating`        | integer| Score from **1 to 5**.                                           |
| `comment_text`  | string | Free-text comment from the respondent.                           |
| `region`        | string | Region of the respondent (e.g. `EMEA`, `Americas`, `APAC`).      |


### 2.2 `user_metadata.csv` — Schema

Each row represents a user.

| Column       | Type    | Description                                            |
|-------------|---------|--------------------------------------------------------|
| `user_email`| string  | Email of the user (join key to survey data).           |
| `full_name` | string  | Full name of the user.                                 |
| `department`| string  | Department (e.g. Engineering, Sales, Marketing, etc.). |
| `country`   | string  | Country of the user.                                   |


> **Note on `region` vs `country`:** The `region` field in survey data is self-reported by the respondent at submission time. The `country` field in user metadata is the user's HR-recorded country. These come from different source systems and may not always align perfectly.

The data contains some realistic imperfections that you might encounter in production systems. Part of the exercise is identifying and handling these appropriately.


---

## 3. Your Tasks

### 3.1 Ingestion

Ingest both CSV files into a data environment of your choice and create two staging structures:

- `stg_survey_results`
- `stg_user_metadata`

You decide what “table” means in your setup:

- Database tables (Postgres, DuckDB, SQLite)
- DataFrames in Python
- dbt models
- Views or temporary tables

What we care about:
- Naming / structure makes sense
- It’s clear where “raw” ends and “cleaned/standardized” begins


---

### 3.2 Cleaning & Standardization

Apply sensible validation and cleaning steps.

You don’t have to do anything overly complex, but we expect you to think about data quality and consistency.

#### For `stg_survey_results`:

- Remove **exact duplicate** submissions, if any
- Ensure `rating` is an integer between **1 and 5**
- Parse and standardize `timestamp` into a proper datetime column
- Normalize `user_email` (e.g. lowercase, trimmed)
- Consider what you’d do if:
  - `user_email` is missing
  - `rating` is outside 1–5
  - `timestamp` is invalid

You can handle issues by:
- Dropping rows
- Flagging them
- Replacing invalid values
- Logging problems (even if just in comments / docs)

Just make sure your choices are **explicit**.

#### For `stg_user_metadata`:

- Ensure `user_email` is unique per user (or document how you handle conflicts)
- Standardize / trim `department` values
- Validate that `country` is present (not null)
- Think about how this table would behave as the company grows (more countries, more departments, etc.)


---

### 3.3 Join into an Analytics-Ready Table

Create a unified, analytics-ready table by joining survey results with user metadata on `user_email`.

We suggest naming this final table:

- `fct_survey_feedback`

At a minimum, it should contain:

- `submission_id`
- `timestamp`
- `user_email`
- `rating`
- `comment_text`
- `region`
- `department`
- `country`

You can add additional derived fields if you think they are useful and still keep the table clear and well-structured (e.g., `rating_bucket`, `year_month`, etc.).

Key things we look at here:

- Does the join make sense?
- How do you handle surveys with missing user metadata (if any)?
- Is the final table structured in a way that’s easy for analytics/BI to use?


---

### 3.4 Aggregations

Using your `fct_survey_feedback` table, produce the following aggregations:


#### 1. Average rating per department

- Output columns: `department`, `avg_rating`

#### 2. Average rating per region

- Output columns: `region`, `avg_rating`

#### 3. Distribution of ratings (1–5) per department

- Output columns: `department`, `rating`, `rating_count`

You can:

- Provide SQL queries
- Generate CSV files with the results
- Show results in a notebook

Choose the format that best demonstrates your approach.


---

### 3.5 (Bonus) Real-Time Architecture Design

This task is **optional** but encouraged if you have time.

Imagine this survey pipeline needs to evolve: instead of batch-processing CSV files, the system must handle **~1,000 survey submissions per minute** in near real-time, with results available for analytics within seconds of submission.

**Your task:**

Create a simple architecture diagram (can be ASCII, a sketch, or any diagramming tool) showing how you would design this real-time pipeline. Include a brief explanation of your choices.

**Consider including:**

- How surveys are ingested (API, message queue, etc.)
- Stream processing or micro-batch approach
- Where validation and cleaning happen
- How data lands in the analytics layer
- How you'd handle failures or late-arriving data

**We're looking for:**

- Reasonable technology choices with brief justification
- Understanding of trade-offs (latency vs. throughput, complexity vs. reliability)
- Awareness of where the batch approach you built would need to change

This doesn't need to be production-ready — a clear diagram with 3–5 sentences explaining your reasoning is enough. Place this in your `design_notes.md` or as a separate file (e.g., `realtime_architecture.md`).


---

## 4. Design Notes / Documentation

Please include a small design/notes document, e.g. `design_notes.md`.

Suggested content:

1. **Tools & stack chosen**
   - e.g. “DuckDB + SQL + one Python script”, “Postgres + dbt”, “Pandas only”, etc.

2. **High-level data flow**
   - A short description or simple diagram:
     - raw → staging → cleaned → final fact table → aggregations

3. **Transformation logic**
   - How you:
     - Cleaned the data
     - Joined the tables
     - Calculated the aggregations

4. **Data quality & validation**
   - What you validate and where (e.g. input, staging, final table)
   - How you would log/alert/fail in a real pipeline

5. **Scalability**
   - How your approach would change if the data volume was 100x larger
   - Any optimizations you’d consider (indexes, partitioning, incremental loads, etc.)

6. **If you had more time…**
   - What improvements you would make
   - How you might productionize this (scheduling, orchestration, testing, monitoring)

This doesn’t have to be long — a couple of well-structured sections with bullet points is enough — but it’s very important for us to understand your thinking.


---

## 5. Suggested Repository Structure

You’re free to structure your project in the way that feels natural to you.  
Here is a **suggested** layout:

```text
.
├── data/
│   ├── survey_results.csv
│   └── user_metadata.csv
│
├── src/
│   ├── ...              # your scripts, SQL files, or notebooks
│   └── ...
│
├── models/              # optional: dbt-style models if you want
│   └── ...
│
├── aggregations/        # optional: CSVs / exports for the 3 aggregations
│   └── ...
│
├── design_notes.md      # your design & reasoning
└── README.md            # this file
