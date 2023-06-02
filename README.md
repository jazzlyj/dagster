# What

Dagster is being used as an orchestration platform for the development, production, and observation of data assets.


## Why (it is useful)

- Frictionless end-to-end development workflow for data teams. Easily build, test, deploy, run, and iterate on data pipelines.
- Modern, flexible architecture built to be fault-tolerant.
- The critical “single plane of glass” for your data team: observe, optimize, and debug even the most complex data workflows.

In short: a much better way to do ETL!

## Environment Variables

## Installation

### PreRequistes 
A working Kubernetes cluster. If needed build a cluster with minikube.

[Download, install, start Minikube](https://minikube.sigs.k8s.io/docs/start/)

### Infrastructure Deployment using Terraform

- This Dagster deployment is backed by a Postgres db to store these dagster internals:

  - Event log
  - Run
  - Schedule

- Terraform is used to deploy the Dagster infra in K8s:

  - namespace
  - secrets (ENV Vars)
  - persistent volume
  - persistent volume claim
  - postgres db
  - postgres service

- Deployment steps:

1) Clone the repo
```bash
git clone 
cd 
```

2) Run terraform
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

### Setup Access to Dagster Database

Run these steps to access the dagster postgres db externally

### First time setup
- Create the K8s context
```bash
# kubectl config set-context <contextname> --namespace=<namespace>

kubectl config set-context docker-registry --namespace=docker-registry
```

Standard out looks like:

    Context "docker-registry" created.


- Set context

```bash
kubectl config use-context all-dagster-dev
```

Standard out looks like:

    Switched to context "all-dagster-dev".

- get pod name

```bash
kubectl get pods
```

Standard out looks like:

    NAME READY STATUS RESTARTS AGE
    postgres--all-dagster-dev 1/1 Running 4 (5h24m ago) 5h25m

- get the service to find out the port that the service is listening on:

```bash
kubectl get services
```

Standard out looks like:

    NAME                                TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
    postgres-service--all-dagster-dev   NodePort   10.99.75.104   <none>        5432:32521/TCP   4m48s

- activate port forwarding of the nodeport (32521) to the db server internal listening port (5432)

```bash
# kubectl port-forward <db podname> --address 0.0.0.0 <service_listening_port>:<pod_listening_port>
kubectl port-forward postgres--all-dagster-dev --address 0.0.0.0 32521:5432
```

#### Any other time

```bash
# kubectl port-forward <db podname> --namespace=<namespace> --address 0.0.0.0 <service_listening_port>:<pod_listening_port>
kubectl port-forward postgres--all-dagster-dev --namespace=all-dagster-dev --address 0.0.0.0 32521:5432
```

### Python and Venv

1. (If necessary) Install Python 3.10, libs/tools

```bash
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.10
python3.10 --version
sudo apt install python3.10-dev
sudo apt install python3.10-venv
```

2. Create and activate a python virtual env

```bash
mkdir -p ~/venv; cd !$
python3.10 -m venv dagster
# Windows
source dagster/Scripts/activate # if the venv was created on windows (bash shell)
# Linux
source ~/venv/dagster/bin/activate
```

2. Upgrade Pip and Setuptools

```bash
pip install --upgrade pip
pip install --upgrade setuptools
```

### Dagster Install:

```bash
pip install dagster dagit dagster-postgres
```

NOTE: make sure the versions are compatible. ie dont run dagster 1.2.4 and dagster-graphql 1.2.3

### Dagster Post-Install [Deployment Configuration](https://docs.dagster.io/deployment/overview#deployment-configuration):

To run this project, you will need to
a) set the env var DAGSTER_HOME

Eg:

```bash
export DAGSTER_HOME=/local/mnt/dagster
```

b) create a dagster.yaml file in DAGSTER_HOME.

The Dagster instance defines the configuration that Dagster needs for a single deployment.

All of the processes and services that make up a Dagster deployment should share a single instance config file, named dagster.yaml, so that they can effectively share information.

_NOTE_ make sure the port number is up to date with the current port number of the node port for the service in K8s

```yaml
storage:
  postgres:
    postgres_db:
      username:
      password:
      hostname: IPADDR
      db_name: dagster_storage
      port:
telemetry:
  enabled: false
```

c) create a workspace.yaml file in DAGSTER_HOME. A workspace file tells Dagster where to find code locations.

This is needed if dagster is running as a daemon. (so it knows what python files to load)

```yaml
load_from:
  - python_file: assets.py
```


## Screenshots

![Dagit UI](./images/Dagit_UI.png)

## Usage/Examples

Start dagster and the dagit UI:

### Locally as a daemon

This command launches both Dagit and the Dagster daemon, allowing you to start a full local deployment of Dagster from the command line.

The dagster-daemon process reads from your Dagster instance file to determine which daemons should be included.

Each of the included daemons then runs on a regular interval in its own threads.

```
dagster dev
```

### Locally launching just a python file

```bash
dagit -f assets.py
```

## Tech Stack

**Client:** Python
**Server:** Dagit UI server via infra deployed in Kubernetes (see above)


## Authors

- Jay Lavine


