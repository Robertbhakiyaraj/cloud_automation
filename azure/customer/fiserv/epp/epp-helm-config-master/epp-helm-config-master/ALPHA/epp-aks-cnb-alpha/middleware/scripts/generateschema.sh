# must run setupenvironment.sh first
echo "----------------------------------"
echo "Generating PSH schema sql files..."
echo
echo "Running ant/setup02InitializeDatabase.xml SQLScriptGeneratorPartition..."
# Procedures - Database - Initialize
# 2.	Run one of:
#ant -f ${TENANT_HOME}/ant/setup02InitializeDatabase.xml SQLScriptGeneratorPartition

ant -f ${TENANT_HOME}/ant/setup02InitializeDatabase.xml SQLScriptGeneratorNoPartition

# 6.	Run the SQL script loadAll-partition.sql. This script performs any other DDL adjustments required by the system.

mkdir -p ${GATEWAY_ROOT}/pshsql/${IMAGE_TAG}/init-config
cp -r ${TENANT_HOME}/init-config/sql ${GATEWAY_ROOT}/pshsql/${IMAGE_TAG}/init-config/

echo
echo "Database schema generation finished"
echo "-----------------------------------"
