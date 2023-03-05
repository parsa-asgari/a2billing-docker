# Setting Up the A2billing Stack In K8s

This document is an effort to present an overview of the A2billing stack in Kubernetes.

The rest of the document is organized as follows:

1. Deployment Details
   - Details about the deployment.
2. Bootstrapping Details
   - An overview of the Bootstrapping process.

## Deployment Details

### Helm Charts

According to the assignment, the stack should be divided into two Helm Charts. Therefore, there are two Helm Charts in the deployment:

- [a2billing-mysql-phpmyadmin](https://github.com/parsa-asgari/a2billing-docker/tree/dev/helm/a2billing-mysql-phpmyadmin)
  - The chart that contains MySQL and phpMyAdmin
- [a2billing-web-sip](https://github.com/parsa-asgari/a2billing-docker/tree/dev/helm/a2billing-web-sip)
  - The chart that contains the Admin and Customer web apps along the Asterisk Sip Server
  - Depends on [a2billing-mysql-phpmyadmin](https://github.com/parsa-asgari/a2billing-docker/tree/dev/helm/a2billing-mysql-phpmyadmin) (Ver 0.1.11)

### Ingress Paths

As noted, there are three main Ingress paths:

- http://cluster/admin/
- http://cluster/customer/
- sip://cluster:5060 (TCP)

### Notes:

Here are the things that are not yet done:

- UDP ingress for sip-server
- Thorough testing of the sip server. However, Telnet connection currently works.
- The phpMyAdmin, Admin, and Customer panels work as intended. However, signing up inside the Customer panel did not work, even though I did enable the signup functionality in the Admin panel. 
  - It didn't seem like a deployment issue. More like a software bug.



## Bootstrapping Details

In order to bootstrap the cluster, it is advised to do the following steps:

1. Clone the Git repo:

   ```bash
   git clone --recurse-submodules -j8 https://github.com/parsa-asgari/a2billing-docker
   ```

2. Change the working directory:

   ```bash
   cd a2billing-docker/helm
   ```

3. Run the shell script:

   ```bash
   bash run_bootstrap_minikube.sh
   ```
4. Stop the cluster

   ```bash
   bash stop_minikube.sh
   ```

### Notes:

- The script assumes you have Minikube installed. Running on a different Kubernetes cluster is not tested.
- The script installs ChartMuseum on your machine to help resolve the [a2billing-web-sip](https://github.com/parsa-asgari/a2billing-docker/tree/dev/helm/a2billing-web-sip)'s chart dependecy.
  - Please do note that the script runs ChartMuseum inside a Screen session. 
- The machine which the script was tested on had a slow HDD. Therefore, there is an option to choose your storage upon bootstrapping. Please choose the relevant storage type when prompted.
- The rest of the bootstrapping script will populate the MySQL database with the mya2billing database which is needed by A2billing.


