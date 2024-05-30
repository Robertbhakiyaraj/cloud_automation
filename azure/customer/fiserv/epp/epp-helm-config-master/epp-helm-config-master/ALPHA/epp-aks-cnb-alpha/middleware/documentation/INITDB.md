## Initialize Database Schema

The PSH schema can be initialized by running the [initdb](../templates/job-initdb.yml) Kubernetes job.

All deployments must be stopped and the job needs to be enabled.

Update [values.yaml](../values.yaml) as follows:

```
gtwsim:
  deploy: false

gui:
  deploy: false

stp:
  deploy: false

# ATTENTION: this job will delete all database objects and data from the database
initdb:
  runjob: true
```

Run Harness pipeline to execute the job and initialize the database.

Verify the job logs and the schema.

Update [values.yaml](../values.yaml) again to enable all deployments and disable the initdb job.

Run the Harness pipeline again to deploy the application.
