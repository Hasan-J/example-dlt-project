import dlt

from sql_database import sql_database


def load_select_tables_from_database() -> None:
    """Use the sql_database source to reflect an entire database schema and load select tables from it."""
    pipeline = dlt.pipeline(
        pipeline_name="mydata", destination="duckdb", dataset_name="dlt_loader"
    )

    source_db = sql_database()

    source_db.Inventory.apply_hints(write_disposition="replace")

    source_db.Movements.apply_hints(
        incremental=dlt.sources.incremental("MovementDate"),
        write_disposition="merge",
        primary_key=["PartID", "MovementID", "MovementDate"],
    )

    info = pipeline.run(source_db)
    print(info)

    # code for dbt transform


def transform_all_tables_from_source():
    pipeline = dlt.pipeline(
        pipeline_name="mydata", destination="duckdb", dataset_name="dbt_transform"
    )

    # make or restore venv for dbt, using latest dbt version
    # NOTE: if you have dbt installed in your current environment, just skip this line
    #       and the `venv` argument to dlt.dbt.package()
    venv = dlt.dbt.get_venv(pipeline)

    # get runner, optionally pass the venv
    dbt = dlt.dbt.package(pipeline, "./transform", venv=venv)

    # run the models and collect any info
    # If running fails, the error will be raised with full stack trace
    models = dbt.run_all()

    for m in models:
        print(
            f"Model {m.model_name} materialized "
            + f"in {m.time} "
            + f"with status {m.status} "
            + f"and message {m.message}"
        )


if __name__ == "__main__":
    load_select_tables_from_database()
    transform_all_tables_from_source()
