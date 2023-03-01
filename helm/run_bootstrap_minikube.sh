#!/bin/bash
echo "==> Assuming the a2billing-web-sip stack is not up and running..."
echo "==> Bilding the a2billing-web-sip helm chart dependencies"
echo ""
cd a2billing-web-sip
helm dependency build
cd ../
echo ""
echo "====> Running: helm install a2billing-web-sip ./a2billing-web-sip/"
echo ""
helm install a2billing-web-sip ./a2billing-web-sip/
echo ""
echo ""
echo "====> What type is the storage of your machine? (HDD or SSD)"
echo -n "->"
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

echo "====> Sleeping for ${SLEEP} seconds. To make sure the helm stack is up and running..."
sleep $SLEEP

mysql_state=$(kubectl get pods -l name=mysql | awk 'FNR == 2 { print $3 }')
if [ $mysql_state = "Pending" ];
then
    echo "==> the MySQL pod status is Pending. Restarting the stack..."
	helm uninstall a2billing-web-sip
    echo ""
    echo ""
    sleep 10
	helm install a2billing-web-sip ./a2billing-web-sip/
    echo ""
    echo ""
    echo "==> Sleeping for ${SLEEP} seconds..."
	sleep $SLEEP
fi

mysql_pod_name=$(kubectl get pods -l name=mysql | awk 'FNR == 2 { print $1 }')
echo ""
echo ""
echo "===> Running: kubectl exec -it $mysql_pod_name -- bash /.docker/mysql_bootstrap.sh"
echo "===> Here are the outputs:"
echo ""
kubectl exec -it $mysql_pod_name -- bash /.docker/mysql_bootstrap.sh

echo ""
echo "Done"