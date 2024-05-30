echo "-----------------------------------------------"
echo "Removing synapse module from application.xml..."
xmllint --shell /u01/oracle/shared/DPSApp/META-INF/application.xml <<XOF
cd //*[contains(text(),'synapse-esb')]/../..
set DELETE
save
XOF

sed -i 's|<module>DELETE</module>||' /u01/oracle/shared/DPSApp/META-INF/application.xml

echo "Finished removing synapse module from application.xml"
echo "-----------------------------------------------------"
echo