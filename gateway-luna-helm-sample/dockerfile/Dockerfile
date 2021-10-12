# requires secret: hsm-server-secret (file that contains password for HSM_USER)
  
# requires ARG: GW_IMAGE (example caapim/gateway:10.1.00)
# requires ARG: MIN_CLIENT (example LunaClient-Minimal-10.3.0-275.x86_64)  
# requires ARG: HSM_USER
# requires ARG: HSM_SERVER
# requires ARG: CERT_NAME
# requires ARG: PARTITION_NAME
  
ARG GW_IMAGE=caapim/gateway:10.1.00
ARG CENTOS_IMAGE=centos:centos7
  
FROM ${CENTOS_IMAGE} AS luna-min-client
  
ARG MIN_CLIENT
ARG HSM_SERVER
ARG HSM_USER
ARG CERT_NAME
ARG PARTITION_NAME
  
RUN yum update -y \
    && yum install -y \
      sed \
      sshpass \
      openssh-clients \
      unzip \
    && yum clean all
  
ENV HOME /home/luna-docker
  
RUN mkdir -p $HOME/config/certs
  
# Copy the Luna Minmal Client tarball to $HOME
COPY ${MIN_CLIENT}.tar $HOME/.
  
# Untar the Luna Minimal Client tarball
RUN tar -xf $HOME/${MIN_CLIENT}.tar -C $HOME; rm -f $HOME/${MIN_CLIENT}.tar
  
# Copy the Chrystoki.conf file from the Minimal Client directory to $HOME/config
ENV MIN_CLIENT_DIR $HOME/${MIN_CLIENT}
RUN cp $MIN_CLIENT_DIR/Chrystoki-template.conf $HOME/config/Chrystoki.conf
  
# Define the following environment variable
ENV ChrystokiConfigurationPath $HOME/config
  
# Update the Chrystoki.conf file paths so the tools work as expoected
RUN $MIN_CLIENT_DIR/bin/64/configurator setValue -s Chrystoki2 -e LibUNIX -v $MIN_CLIENT_DIR/libs/64/libCryptoki2.so \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s Chrystoki2 -e LibUNIX64 -v $MIN_CLIENT_DIR/libs/64/libCryptoki2_64.so \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s Misc -e ToolsDir -v $MIN_CLIENT_DIR/bin/64 \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s "LunaSA Client" -e SSLConfigFile -v $MIN_CLIENT_DIR/openssl.cnf \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s "LunaSA Client" -e ClientPrivKeyFile -v $HOME/config/certs/dockerlunaclientKey.pem \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s "LunaSA Client" -e ClientCertFile -v $HOME/config/certs/dockerlunaclient.pem \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s "LunaSA Client" -e ServerCAFile -v $HOME/config/certs/CAFile.pem  \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s "Secure Trusted Channel" -e ClientTokenLib -v $MIN_CLIENT_DIR/libs/64/libSoftToken.so \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s "Secure Trusted Channel" -e SoftTokenDir -v $HOME/config/stc/token \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s "Secure Trusted Channel" -e ClientIdentitiesDir -v $HOME/config/stc/client_identities \
    && $MIN_CLIENT_DIR/bin/64/configurator setValue -s "Secure Trusted Channel" -e PartitionIdentitiesDir -v $HOME/config/stc/partition_identities
  
# copy the hsm appliance server certificate
RUN --mount=type=secret,id=hsm-server-secret,dst=/.hsm-server-secret sshpass -f /.hsm-server-secret scp -oStrictHostKeyChecking=no ${HSM_USER}@${HSM_SERVER}:server.pem $HOME/config/certs
  
# Register the appliance server certificate with the Client
RUN $MIN_CLIENT_DIR/bin/64/vtl addServer -c $HOME/config/certs/server.pem -n ${HSM_SERVER} 
  
# Following is only needed if you need to generate client key/certificate (or you can use existing one)
# Create a Luna HSM Client certificate for the Docker container ($MIN_CLIENT_DIR/bin/64/vtl createCert -n <cert name>)
# or copy private key/certificate to $HOME/config/certs
RUN $MIN_CLIENT_DIR/bin/64/vtl createCert -n ${CERT_NAME}
# Copy the client certificate to the SafeNet Luna Network HSM appliance
RUN --mount=type=secret,id=hsm-server-secret,dst=/.hsm-server-secret sshpass -f /.hsm-server-secret scp -oStrictHostKeyChecking=no $HOME/config/certs/${CERT_NAME}.pem ${HSM_USER}@${HSM_SERVER}:
  
# Register client
RUN --mount=type=secret,id=hsm-server-secret,dst=/.hsm-server-secret sshpass -f /.hsm-server-secret ssh ${HSM_USER}@${HSM_SERVER} "client register -client ${CERT_NAME} -hostname ${CERT_NAME}"
# Assign client to partition
RUN --mount=type=secret,id=hsm-server-secret,dst=/.hsm-server-secret sshpass -f /.hsm-server-secret ssh ${HSM_USER}@${HSM_SERVER} "client assignpartition -client ${CERT_NAME} -partition ${PARTITION_NAME}"
# Disable ip check
RUN --mount=type=secret,id=hsm-server-secret,dst=/.hsm-server-secret sshpass -f /.hsm-server-secret ssh ${HSM_USER}@${HSM_SERVER} "ntls ipcheck disable"
    
RUN sed -i -e 's#'$HOME'/config#/usr/local/luna/config#g' -e 's#'$HOME'/LunaClient-Minimal-\([0-9\.-]\+\)x86_64#/usr/local/luna#g' $ChrystokiConfigurationPath/Chrystoki.conf
  
# Copy and extract JDK11 patch
RUN mkdir -p /tmp/patch
   
COPY 630-000419-001_SW_Patch_jsp_fix_jdk11_UC_Clnt_10.2.0_Custom_Release.zip /tmp/patch/.
   
# Extract patch to /tmp/patch
RUN unzip -p /tmp/patch/630-000419-001_SW_Patch_jsp_fix_jdk11_UC_Clnt_10.2.0_Custom_Release.zip | tar xf - --strip 1 -C /tmp/patch/. \
    && rm -f /tmp/patch/630-000419-001_SW_Patch_jsp_fix_jdk11_UC_Clnt_10.2.0_Custom_Release.zip
  
#
# Build new GW image with luna client
#
FROM ${GW_IMAGE}
  
ARG MIN_CLIENT
  
# Add the luna client
USER root
COPY ${MIN_CLIENT}.tar /tmp
ENV MIN_CLIENT_HOME /usr/local/luna
RUN mkdir -p ${MIN_CLIENT_HOME} \
    && tar xvf /tmp/${MIN_CLIENT}.tar --strip 1 -C ${MIN_CLIENT_HOME} \
    && rm -f /tmp/${MIN_CLIENT}.tar
  
COPY --from=luna-min-client "/home/luna-docker/config" "${MIN_CLIENT_HOME}/config"
ENV ChrystokiConfigurationPath /usr/local/luna/config
ENV PATH="${MIN_CLIENT_HOME}/bin/64:${PATH}"
  
#
# For non patched version, copy required jsp files from ${MIN_CLIENT_dir} directly
#
COPY --from=luna-min-client /tmp/patch/LunaProvider.jar /opt/SecureSpan/Gateway/runtime/lib/ext/
COPY --from=luna-min-client /tmp/patch/linux/64/libLunaAPI.so /opt/SecureSpan/Gateway/runtime/lib/ext/

#
# Update security provider order as required by Luna client.  This can be done either here or in the helmchart.
# For this example, it is done in the helmchart so that the provider order can be reverted if there is a need
# to disable Luna HSM.  Uncomment if provider order is to be set at image creation time.
#RUN echo "security.provider.1=SUN" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.2=SunJCE" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.3=SunJGSS" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.4=SunSASL" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.5=XMLDSig" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.6=SunPCSC" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.7=JdkLDAP" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.8=JdkSASL" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.9=SunPKCS11" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.10=com.safenetinc.luna.provider.LunaProvider" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.11=SunRsaSign" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.12=SunEC" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "security.provider.13=SunJSSE" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security

#  
# Override the default Luna configuration.  Like above, for this example, it is configured in Helm. 
# Uncomment if this configuration is to be set at image creation time. 
#RUN echo "com.safenetinc.luna.provider.createExtractablePrivateKeys=true" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security \
#    && echo "com.safenetinc.luna.provider.createExtractableSecretKeys=true" >> /opt/SecureSpan/Gateway/runtime/etc/ssg.security