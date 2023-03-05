#!/bin/bash

echo "**********************************************************"
echo " ----- Bootstrapping the A2billing Kubernetes Stack ----- " 
echo ""
echo " *** ===> Assuming the existence of a Minikube Cluster...."
echo ""

echo "Please do make sure that your working directory is inside a2billing-docker/helm/"
echo ""

echo "==> The current working directory is"
echo $(echo $PWD)
echo ""

echo " ====> Enabling the Nginx Ingress addon"
minikube addons enable ingress

echo ""
echo " ====> Installing ChartMuseum and running it on port 8080..."
echo " ====> Please do note that for the sake of simplicity, ChartMuseum is being ran inside a Screen session..."
curl https://raw.githubusercontent.com/helm/chartmuseum/main/scripts/get-chartmuseum | bash
screen -d -m chartmuseum --debug --port=8080   --storage="local"   --storage-local-rootdir="./chartstorage"
echo ""

echo " ====> Installing cm-push Helm plugin..."
helm plugin install https://github.com/chartmuseum/helm-push
helm repo add chartmuseum http://localhost:8080
helm repo update
echo ""

minikube_ip=$(minikube ip)
if [ $(cat /etc/hosts|grep ${minikube_ip} | awk 'FNR == 1 { print $1 }') == "" ];
then
echo "======> Adding cluster entry to /etc/hosts (for Ingress)"
echo "======> Running echo '${minikube_ip} cluster' | sudo tee -a /etc/hosts"
echo "${minikube_ip} cluster" | sudo tee -a /etc/hosts
else
echo "======> cluster entry already exists in /etc/hosts"
fi
echo ""

echo "======> Assuming the a2billing-web-sip stack is not up and running..."
echo "======> Bilding the a2billing-web-sip helm chart dependencies"
echo ""

helm cm-push a2billing-mysql-phpmyadmin/ chartmuseum
cd a2billing-web-sip
helm dependency build
cd ../

echo ""
echo "======> Updating Helm repo..."
echo ""

echo ""
echo "======> Running: helm install a2billing-web-sip chartmuseum/a2billing-web-sip"
echo ""


helm cm-push a2billing-web-sip/ chartmuseum
helm install a2billing-web-sip chartmuseum/a2billing-web-sip

echo ""
echo ""
echo "======> What type is the storage of your machine? (HDD or SSD)"
echo -n "--> "
read STORAGE
echo ""
case $STORAGE in
  SSD | ssd)
    SLEEP=20
    ;;

  HDD | hdd)
    SLEEP=60
    ;;

  *)
    SLEEP=20
    ;;
esac

echo "======> Sleeping for ${SLEEP} seconds. To make sure the helm stack is up and running..."
sleep $SLEEP

mysql_state=$(kubectl get pods -l name=mysql | awk 'FNR == 2 { print $3 }')
if [ $mysql_state = "Pending" ];
then
    echo "======> the MySQL pod status is Pending. Restarting the stack..."
	helm uninstall a2billing-web-sip
    echo ""
    echo ""
    sleep 10
	helm install a2billing-web-sip chartmuseum/a2billing-web-sip
    echo ""
    echo ""
    echo "======> Sleeping for ${SLEEP} seconds..."
	sleep $SLEEP
fi

mysql_pod_name=$(kubectl get pods -l name=mysql | awk 'FNR == 2 { print $1 }')
echo ""
echo ""
echo "======> Running: kubectl exec -it $mysql_pod_name -- bash /.docker/mysql_bootstrap.sh"
echo "======> Here are the outputs:"
echo ""
kubectl exec -it $mysql_pod_name -- bash /.docker/mysql_bootstrap.sh
echo ""
echo ""

echo "======> Setting up ingress for Asterisk"
echo "======> Running configmap patch for Nginx Ingress..."
echo ""
kubectl patch configmap tcp-services -n ingress-nginx --patch '{"data":{"5060":"default/sipserver:5060"}}'
echo ""
echo "======> Patching the Nginx Ingress Controller..."
kubectl patch deployment ingress-nginx-controller --patch "$(cat ingress-nginx-controller-patch.yaml)" -n ingress-nginx
echo ""

echo "You may use the cluster via the addresses below"
echo " 1. http://cluster/admin/"
echo " 2. http://cluster/customer/"
echo " 3. http://cluster/phpmyadmin/"
echo " 4. (SIP) telnet cluster 5060"

echo " * ==> Please do make sure to include the trailing slash at the end of the URLs"

echo "Done."
echo "**********************************************************"