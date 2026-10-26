# olist_project (dbt)

The dbt project for the Olist ELT pipeline. See the [main README](../README.md) for architecture, data model and setup.

- `models/staging/`: one view per raw source table (renaming, typing, dedup) plus source and column tests
- `models/marts/`: star schema tables (5 dimensions, 3 facts)
- `snapshots/`: SCD Type 2 snapshot of sellers
- `tests/`: custom singular tests (`assert_no_negative_prices`, `assert_delivery_after_purchase`)
