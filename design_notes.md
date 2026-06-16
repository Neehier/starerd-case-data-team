WIP

---

https://dataskew.io/blog/sql-vs-python-data-transformations/

https://duckdb.org/2025/04/04/dbt-duckdb

https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview?version=2.0&name=Fusion

^^
✅ Build on separate marts thoughtfully. While we strive to preserve a narrowing DAG up to the marts layer, once here things may start to get a little less strict. A common example is passing information between marts at different grains, as we saw above, where we bring our orders mart into our customers marts to aggregate critical order data into a customer grain. Now that we’re really ‘spending’ compute and storage by actually building the data in our outputs, it’s sensible to leverage previously built resources to speed up and save costs on outputs that require similar data, versus recomputing the same views and CTEs from scratch. The right approach here is heavily dependent on your unique DAG, models, and goals — it’s just important to note that using a mart in building another, later mart is okay, but requires careful consideration to avoid wasted resources or circular dependencies.
(https://docs.getdbt.com/best-practices/how-we-structure/4-marts?version=2.0)