## How To Create And Setup A New Tenant Environment In PKS

### Create Kubernetes namespace
<em style="color: red;">TODO: add details</em>

### Setup ingress tls certificate
The epp-tls-cert secret referenced by [ingress.yml](templates/ingress.yml) must first be deployed to the namespace using a Harness pipeline.
The epp-tls-cert secret details are stored in the Harness Vault

The [ingress.yml](templates/ingress.yml) manifest enables
external access to the application UI through a load balancer

### Setup tenant attributes in source control

* Obtain client profile name for this tenant and update [values.yaml](values.yaml)
* Request database schema creation for tenant deployment <em style="color: red;">(TODO: Link to documentation)</em>
* Obtain Database URL, username and password and update [values.yaml](values.yaml)
* Request creation of MQ queues for tenant deployment <em style="color: red;">(TODO: Link to documentation)</em>
* Obtain MQ queue connection factory bindings file and update [.bindings](resources/mqm/bindings/connfactory/.bindings) 
* Obtain MQ queue bindings file, name it queue.bindings and zip into [queue.bindings.zip](resources/mqm/bindings/queue/queue.bindings.zip)
* Obtain Weblogic truststore.jks file and commit to [truststore.jks](resources/mqm/security/truststore.jks) <em style="color: red;">(TODO: Link to documentation)</em>
* Update [values.yaml](values.yaml) with truststore password
* Obtain any other attributes custom to the tenant and environment
* Update [values.yaml](values.yaml) and other configuration files as needed

### Configure Kubernetes namespace in Harness
Create Environment and Cloud Infrastructure definitions to enable access to the Kubernetes namespace from Harness 

### Create Harness pipeline
Create a Harness service definition, workflow and pipeline

Run the Harness pipeline to deploy the tenant

### Use Helm to generate local manifest files
Use helm to generate manifest files locally to simulate the Harness pipeline

Update [values-local.yaml](values-local.yaml) as needed and run helm command:

`helm template ./ -f values-local.yaml --output-dir tmp`

Generated files can be executed with kubectl:

`kubectl apply -f tmp/psh/templates/job-generatepshschema.yml`

### HOWTO

- [Initialize Database Schema](documentation/INITDB.md)
- [Run Custom QBOL](documentation/RUNCUSTOMQBOL.md)
- [Access UI](documentation/ACCESSUI.md)
- [Generate PSH Schema DDL](documentation/GENERATESCHEMADDL.md)




