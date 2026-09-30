\# Olist E-Commerce Analytics Engineering Pipeline



An end-to-end analytics engineering pipeline built on the Olist Brazilian E-Commerce public dataset, using \*\*dbt Core\*\*, \*\*Snowflake\*\*, and \*\*Apache Airflow\*\*. Built as a personal portfolio project to demonstrate practical data engineering and data quality practices: building a star schema, embedding automated data quality tests, tracking historical changes (SCD Type 2), and orchestrating the pipeline with Airflow in Docker.



\## Tech Stack

\- \*\*Snowflake\*\* — cloud data warehouse

\- \*\*dbt Core\*\* — transformation, testing, and snapshots

\- \*\*Apache Airflow\*\* — orchestration, containerized with Docker

\- \*\*Python / SQL\*\*

\- \*\*Git / GitHub\*\* — version control



\## Architecture



```

Raw source tables (9)  →  Staging models (dbt views)  →  Marts / star schema (dbt tables)

&#x20;                             ↓ tested                        ↓ tested

&#x20;                       (not-null, unique,              (referential integrity,

&#x20;                        accepted-values)                 business-rule tests)

```



Orchestrated end to end by an Airflow DAG: `dbt run staging → dbt test staging → dbt run marts → dbt test marts`, so quality checks gate promotion between layers.



\## Data Model



\*\*Dimensions:\*\* `dim\_customers`, `dim\_sellers`, `dim\_products`, `dim\_geolocation`, `dim\_date`

\*\*Facts:\*\* `fact\_order\_items`, `fact\_payments`, `fact\_reviews`



\## Data Quality



\- \*\*19 automated dbt tests\*\*: `not\_null`, `unique`, `relationships` (referential integrity), `accepted\_values`, plus 2 custom singular tests (`assert\_no\_negative\_prices`, `assert\_delivery\_after\_purchase`).

\- \*\*3 real data quality defects found and fixed\*\* during ingestion:

&#x20; - A CSV header-detection failure on load (Snowflake's upload wizard didn't parse headers correctly for one source file) — fixed by explicitly setting header/delimiter config on re-upload.

&#x20; - Genuine typos in the source data itself (`product\_name\_lenght`, `product\_description\_lenght`) — corrected via aliasing in the staging layer.

&#x20; - A many-to-one duplication issue in raw geolocation data — resolved with a window-function deduplication (`ROW\_NUMBER()` partitioned by zip code).

\- \*\*Slowly Changing Dimension (Type 2)\*\* history tracking on `dim\_sellers.seller\_state`, implemented via a dbt snapshot (`check` strategy) and verified with a live simulated data change.



&#x20; !\[SCD Type 2 verification](docs/screenshots/scd\_type2\_seller\_state\_change.png)



\## Orchestration



The pipeline is orchestrated by an Airflow DAG (`airflow/dags/olist\_pipeline.py`), containerized with Docker. Verified running successfully end to end against the live Snowflake account:



!\[Airflow DAG successful run](olist\_project/docs/airflow\_dag\_success.png)



\### A note on getting here

Getting Airflow running wasn't smooth, and that troubleshooting process is part of what this project demonstrates. The Docker build initially failed with SSL errors on a corporate-managed laptop, traced to endpoint security software intercepting container network traffic — confirmed when IT-level certificate access was explicitly blocked. Moving to GitHub Codespaces fixed the build, but surfaced a separate Postgres connection-timeout issue between Airflow's API server and its metadata database, reproduced identically across multiple fresh cloud environments despite isolating executor type, network configuration, and environment freshness as variables. Re-testing the exact same setup on a personal, non-corporate laptop resolved it cleanly — confirming both issues were environment-specific, not flaws in the pipeline design itself.



\## Setup



1\. Create a Snowflake account and load the 9 raw Olist tables into a database (`OLIST`) and schema (`PUBLIC`).

2\. Install dbt Core and the Snowflake adapter: `pip install dbt-core dbt-snowflake`

3\. Configure `\~/.dbt/profiles.yml` with your Snowflake credentials (see `olist\_project/dbt\_project.yml` for the profile name).

4\. From `olist\_project/`, run:

```

&#x20;  dbt run

&#x20;  dbt test

&#x20;  dbt snapshot

```

5\. To run via Airflow: from `airflow/`, create a `profiles.yml` with your Snowflake credentials (excluded from this repo via `.gitignore`), then:

```

&#x20;  docker compose build

&#x20;  docker compose up airflow-init

&#x20;  docker compose up -d

```

&#x20;  Open `http://localhost:8080`, enable the `olist\_pipeline` DAG, and trigger a run.



\## Repository Structure



```

olist-dbt-airflow-snowflake/

├── olist\_project/          # dbt project (staging models, marts, snapshots, tests)

├── airflow/                # Airflow DAG, Dockerfile, docker-compose.yaml

└── docs/screenshots/       # Evidence screenshots

```

