## Run Custom QBOL

The PSH schema can be initialized by running the [customqbol](templates/job-customqbol.yml) Kubernetes job.

All deployments must be stopped and the job needs to be enabled.

Update [values.yaml](../values.yaml) as follows:

```
gtwsim:
  deploy: false

gui:
  deploy: false

stp:
  deploy: false

customqbol:
  runjob: true
```

Run Harness pipeline to execute the job and initialize the database.

Verify the job logs.

Update [values.yaml](../values.yaml) again to enable all deployments and disable the this job.

Run the Harness pipeline again to deploy the application.