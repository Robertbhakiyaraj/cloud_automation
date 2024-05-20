# must run setupenvironment.sh first
echo "---------------------------------------------"
echo "Creating no partition PSH schema sql files..."
echo
echo "Running ant/setup02InitializeDatabase.xml SQLScriptGeneratorPartition..."
# Procedures - Database - Initialize
# Installation guide 2.	Run one of:
#ant -f ${TENANT_HOME}/ant/setup02InitializeDatabase.xml SQLScriptGeneratorPartition

ant -f ${TENANT_HOME}/ant/setup02InitializeDatabase.xml SQLScriptGeneratorNoPartition

cd ${TENANT_HOME}/init-config/sql

# Installation guide 5. Run the SQL script Q5Init-PROD* (generated above). This script creates the initial DDL, containing generic DDL definitions such as that for tables, indexes, and partitions.
sqlplus ${Q5DataSourceUser}/${Q5DataSourcePassword}@${Q5DataSourceURL#*@} @Q5Init-PROD_nopartition.sql

# Installation guide 6.	Run the SQL script loadAll-partition.sql. This script performs any other DDL adjustments required by the system.
# EP TODO: installation guide does not specify to run loadAll.sql for no partition
sqlplus ${Q5DataSourceUser}/${Q5DataSourcePassword}@${Q5DataSourceURL#*@} @loadAll.sql

echo "Database schema creation finished"
echo "---------------------------------"
echo
