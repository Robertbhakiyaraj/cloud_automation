# must run setupenvironment.sh first
echo "----------------------------------"
echo "Generating PSH schema sql files..."
echo
jarfilename=$(basename $(ls $TENANT_HOME/DPSApp/lib/psh-webapp-*) .jar)
echo $jarfilename
version=${jarfilename#psh-webapp-}
version=${jarfilename/-classes}
echo $version
echo "Running ant/setup02InitializeDatabase.xml SQLScriptGeneratorPartition..."
# Procedures - Database - Initialize
# 2.	Run one of:
ant -f ${TENANT_HOME}/ant/setup02InitializeDatabase.xml SQLScriptGeneratorPartition

# ant -f ant/setup02InitializeDatabase.xml SQLScriptGeneratorNoPartition

# 6.	Run the SQL script loadAll-partition.sql. This script performs any other DDL adjustments required by the system.

mkdir -p ${GATEWAY_ROOT}/pshsql/${version}/init-config
cp -r ${TENANT_HOME}/init-config/sql ${GATEWAY_ROOT}/pshsql/${version}/init-config/

echo
echo "Database schema generation finished"
echo "-----------------------------------"
