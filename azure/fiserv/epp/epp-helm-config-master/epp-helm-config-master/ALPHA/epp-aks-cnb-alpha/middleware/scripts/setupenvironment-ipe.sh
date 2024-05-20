echo "-----------------------------"
echo "Setting up the environment..."
echo
echo "Setting up container for client: ${CLIENT}"
# used to specify the client being deployed
echo "environment.CLIENT=${CLIENT}" >> ${TENANT_HOME}/overrides.properties
# used to specify where to create gateway directories
echo "environment.GATEWAY_DIR=${GATEWAY_ROOT}" >> ${TENANT_HOME}/overrides.properties
# following parameters should be hardcoded in dps_environment.xml
echo "environment.APPSERVER_PORT=7001" >> ${TENANT_HOME}/overrides.properties
echo "environment.APPSERVER_HOST=localhost" >> ${TENANT_HOME}/overrides.properties

DbHostname=${Q5DataSourceURL%:*}; DbHostname=${DbHostname#*@}; echo "DbHostname: $DbHostname"
echo "environment.DB_HOST=$DbHostname" >> ${TENANT_HOME}/overrides.properties

DbPort=${Q5DataSourceURL#*@*:}; DbPort=${DbPort%/*}; echo "DbPort: $DbPort"
echo "environment.DB_PORT=$DbPort" >> ${TENANT_HOME}/overrides.properties

DbServicename=${Q5DataSourceURL#*/}; echo "DbServicename: $DbServicename"
echo "environment.DB_SERVICE_NAME=$DbServicename" >> ${TENANT_HOME}/overrides.properties

echo "environment.DB_SCHEMA=$Q5DataSourceIpeUser" >> ${TENANT_HOME}/overrides.properties

echo "environment.IPE_SHARED_SCHEMA=$Q5DataSourceIpeSharedUser" >> ${TENANT_HOME}/overrides.properties

echo "environment.DB_PASSWORD=$Q5DataSourcePassword" >> ${TENANT_HOME}/overrides.properties
echo "environment.ORACLE_HOME=/usr/lib/oracle/21/client64" >> ${TENANT_HOME}/overrides.properties


echo "Preparing the environment..."
ant -q -f ${TENANT_HOME}/ant/setupAll.xml 00BuildConfiguration
ant -q -f ${TENANT_HOME}/ant/setup00CopyConfigurationFiles.xml setup

echo "Finished setting up the environment"
echo "-----------------------------------"
echo
