# Install/Uninstall this project into a Kubernetes Cluster
# This is for demonstration purposes only and does not represent
# any form of a production ready implementation.
# It is recommended that this demo is run against sandbox environments only

install:
	kubectl create namespace layer7
	kubectl create namespace opa
	kubectl create -k ./gateway
	kubectl create -k ./opa
	helm repo add layer7 https://caapim.github.io/apim-charts/
	helm install ssg --set license.accept=true -f ./gateway/helm/gateway-values.yaml -n layer7 layer7/gateway

uninstall:
	kubectl delete namespace layer7
	kubectl delete namespace opa