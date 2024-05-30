# must run setupenvironment.sh first
echo "--------------------------------------------------"
echo "Running RunQBOL.xml -Dqbol.file=customqbol.xml ..."
ant -v -f ${TENANT_HOME}/ant/RunQBOL.xml -Dqbol.file=customqbol.xml

echo
echo "Finished running custom qbol"
echo "----------------------------"
echo