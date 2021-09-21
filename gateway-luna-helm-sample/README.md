# Gateway Container With Luna HSM Integration

## Description
This sample includes modified gateway chart to work with Gateway container integrating with Luna HSM

## Prerequisites/Dependencies
* Luna HSM hardware
* Luna enabled gateway container (created using provided dockerfile)
* Helm and k8s command line installed and configured.
* Rancher environment

## Installation
1. Modify values in values.yaml file
    * Required Values
        ```yaml
            image:
                registry: <DOCKER_REGISTRY>
                repository: <CUSTOM_LUNA_GATEWAY_CONTAINER_IMAGE_PATH>
                tag: <TAG>
                pullPolicy: Always
                # Will create a Registry secret and apply it to the Gateway
                secretName: <DOCKER_REGISTRY_KEY_NAME>
                credentials:
                    username: <USER_NAME>
                    password: <API_KEY>
                    email: <EMAIL>
            ## FQDN for Ingress
            clusterHostname: <CLUSTER_HOSTNAME>
        ```

1. To install Gateway onto Rancher 
`helm install my-luna-gateway gateway -f ./gateway/ingress-values.yaml --set-file "license.value=<PATH_TO_LICENSE_FILE>" --set "license.accept=true"`

1. Enable Luna via Policy Manager follow [this document](https://techdocs.broadcom.com/us/en/ca-enterprise-software/layer7-api-management/api-gateway/10-1/install-configure-upgrade/configure-the-appliance-gateway/configure-hardware-security-modules-hsm/configure-safenet-luna-sa-hsm-parent/configure-the-safenet-luna-hsm-client-v102.html) Step 5, task 2 to 5
1. To Uninstall Gateway `helm uninstall my-luna-gateway`

## Additional Information
To build Luna enabled gateway container, please follow [this document](). 

## Known Limitations
The sample chart is limited to work with Rancher environment. 
