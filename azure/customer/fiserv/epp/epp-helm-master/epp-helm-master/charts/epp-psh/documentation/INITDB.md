## Initialize Database Schema

The PSH schema can be initialized by running the [initDb](../templates/job-initdb.yml) Kubernetes job.

The gui, stp, and gtwsim deployments will be stopped when initDb runjob is set to true and the Harness pipeline is executed.

Update [values.yaml](../values.yaml) as follows:

```
# ATTENTION: this job will delete all database objects and data from the database
initDb:
  runjob: true
```

Run the Harness pipeline to execute the job and initialize the database.

Review the initDb job logs to verify the schema has been initialized correctly.

Update [values.yaml](../values.yaml) to disable the initDb job by setting runjob to false.

Run the Harness pipeline to start the gui, stp and gtwsim deployments.
