# Install/Uninstall this project into a Kubernetes Cluster
# This is for demonstration purposes only and does not represent
# any form of a production ready implementation.
# It is recommended that this demo is run against sandbox environments only

install:
	kubectl create namespace layer7
	kubectl create -k ./gateway
	helm repo add layer7 https://caapim.github.io/apim-charts/
	helm install -n layer7 ssg -f ./gateway/helm/myvalues.yaml layer7/gateway

uninstall:
	kubectl delete namespace layer7

grafana: 
	kubectl port-forward -n layer7 svc/ssg-grafana 3000 