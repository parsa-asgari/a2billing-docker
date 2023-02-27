#!/bin/bash
echo "Assuming the a2billing-mysql-phpmyadmin stack is not up and running..."
echo ""
echo "Running: helm install a2billing-mysql-phpmyadmin ./a2billing-mysql-phpmyadmin/"
echo ""
helm install a2billing-mysql-phpmyadmin ./a2billing-mysql-phpmyadmin/

sleep 30

mysql_state=$(kubectl get pods -l name=mysql | awk 'FNR == 2 { print $3 }')
echo "The MySQL state is: ${mysql_state}"
# if ["$mysql_state"=="Pending"]
# then
# 	helm uninstall a2billing-mysql-phpmyadmin
# 	helm install a2billing-mysql-phpmyadmin ./a2billing-mysql-phpmyadmin/
# 	sleep 30
# fi

mysql_pod_name=$(kubectl get pods -l name=mysql | awk 'FNR == 2 { print $1 }')
echo "======> the pod's name is ${mysql_pod_name}"
echo "Running: kubectl exec -it ${mysql_pod_name} -- bash /.docker/mysql_bootstrap.sh"
kubectl exec -it ${mysql_pod_name} -- bash /.docker/mysql_bootstrap.sh
