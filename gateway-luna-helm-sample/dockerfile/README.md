# Dockerfile for Gateway with Luna HSM Integration 

## Description
This sample Dockerfile builds a Gateway 10.1 image that can connect to Luna HSM 7.

## Prerequisites/Dependencies
The Dockerfile has specific steps to install the Luna Client 10.2 + Luna Client jdk11 patch.  The following files are required from Thales:

- 10-000401-002_SW_Minimal_Client_10.2_Linux_RevA.tar
- 630-000419001_SW_Patch_jsp_fix_jdk11_UC_Clnt_10.2.0_Custom_Release.zip 

## Installation
To build the image:

1. Rename 610-000401-002_SW_Minimal_Client_10.2_Linux_RevA.tar to LunaClient-Minimal-10.2.0-111.x86_64.tar.

2. Place both the LunaClient-Minimal-10.2.0-111.x86_64.tar and zip patch file to the same directory as the Dockerfile.

3. Create a file named hsm-server-secret.txt and add the password for the <HSM_USER> account.

4. Execute the following command to build the image:
   `DOCKER_BUILDKIT=1 docker build -t <IMAGE_NAME> --no-cache --build-arg MIN_CLIENT=LunaClient-Minimal-10.2.0-111.x86_64 --build-arg HSM_USER=<HSM_USER> --build-arg HSM_SERVER=<HSM_SERVER> --build-arg CERT_NAME=<CERT_NAME> --build-arg PARTITION_NAME=<PARTITION_NAME> --secret id=hsm-server-secret,src=hsm-server-secret.txt -f Dockerfile .`

   **Note**: Re-running docker build will fail unless the client registration is commented out or the previous registration is deleted from the HSM.

5. Start up the container.  At this time, the Policy Manager must be used to enable the HSM Keystore. Click on Manage Private Keys / Manage Keystore/ Enable SafeNet HSM and enter the required information.

6. Scale down and scale up the Gateway.  The Gateway is now using Luna HSM.

## Known Limitations

Policy Manager must be  used to enable HSM on the Gateway once the Gateway has been started.

