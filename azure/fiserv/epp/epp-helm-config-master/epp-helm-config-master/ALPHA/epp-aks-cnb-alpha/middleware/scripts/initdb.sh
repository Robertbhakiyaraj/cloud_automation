# must run setupenvironment.sh first
echo "--------------------------------------"
echo "Running PSH database initialization..."
echo
echo "----------------------------------------------------------"
echo "Running ant/setup02InitializeDatabase.xml loadCreateAll..."


ant -f ${TENANT_HOME}/ant/setup02InitializeDatabase.xml loadCreateAll

#If you have additional QBOL data to load, use the following ant task once you have completed the initial data load:
#ant -f ant/RunQBOL.xml -Dqbol.file=xyz.xml
#Release notes for US_Solution specify running updateAll.xml (also specified in project.properties environment.INIT_QBOL)
ant -f ${TENANT_HOME}/ant/setup02InitializeDatabase.xml runQbol -Dqbol.file=updateAll.xml

# Installation guide 4. Optional: In order to load test data, run the following ant target:
ant -f ${TENANT_HOME}/ant/setup02InitializeDatabase.xml runQbol -Dqbol.file=test/createAll-test.xml

# Installation guide 6. Run the SQL script:
cd ${TENANT_HOME}/init-config/sql/sqlplusloader
echo "---------------------------------------------"
echo "Running sqlplus @loadAll-sqlplusloader.sql..."
sqlplus ${Q5DataSourceUser}/${Q5DataSourcePassword}@${Q5DataSourceURL#*@} @loadAll-sqlplusloader.sql

# Installation guide 7. Run the ant target:
echo "--------------------------------------"
echo "Running ReserveExtraArchiveDays.xml..."
ant -f ${TENANT_HOME}/ant/ReserveExtraArchiveDays.xml -DINIT_DB_WITH_DEFAULT_DATE=true

echo
echo "PSH database initialization finished"
echo "------------------------------------"
echo