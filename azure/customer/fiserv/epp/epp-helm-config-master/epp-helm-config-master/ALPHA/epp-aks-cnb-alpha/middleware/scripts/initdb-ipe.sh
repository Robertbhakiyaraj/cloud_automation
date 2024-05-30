# must run setupenvironment.sh first
echo "--------------------------------------"
echo "Running PSH database initialization..."
echo
echo "----------------------------------------------------------"
echo "Running ant/setup02InitializeDatabase.xml loadCreateAll..."

# Installation guide 3. Load the initial set of data into the database as defined in [PSH_INSTALL_DIR]/init-config/qbol/createAll.xml
ant -f ${TENANT_HOME}/ant/setupAll.xml 01CreateDatabase
ant -f ${TENANT_HOME}/ant/setupAll.xml 02InitializeDatabase

echo
echo "PSH database initialization finished"
echo "------------------------------------"
echo