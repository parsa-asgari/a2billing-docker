

echo "**********************************************************"
echo " ----- Stopping the A2billing Kubernetes Stack ----- " 
echo ""
echo " ====> Deleting the resources in ingress-nginx namespace"
echo ""
kubectl delete all  --all -n ingress-nginx
echo ""
echo " ====> Uninstalling the a2billing-web-sip helm chart"
echo ""
helm uninstall a2billing-web-sip
echo ""

echo " ====> Deleting MySQL's data inside Minikube..."
docker exec -it minikube sh -c 'cd /mysql-data && rm -rf * && exit'
echo ""
echo "Done."
echo "**********************************************************"
