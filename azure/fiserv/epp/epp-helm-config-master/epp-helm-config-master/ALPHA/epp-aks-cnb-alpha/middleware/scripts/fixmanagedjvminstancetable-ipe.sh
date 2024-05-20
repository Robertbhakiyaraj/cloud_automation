echo "-----------------------------------------------------"
echo "EPDT-46887 Fixing missing ManagedJVMInstance table..."
#US_Solution missing call to createManagedJVMInstances.sql from loadAll.sql and loadAll-partition.sql
#https://enterprise-jira.onefiserv.net/browse/EPDT-46887

sed -i '/@custom-properties.sql/a @createManagedJVMInstances.sql' ${TENANT_HOME}/init-config/sql/loadAll.sql
sed -i '/@custom-properties.sql/a @createManagedServerInstance.sql' ${TENANT_HOME}/init-config/sql/loadAll.sql

echo "Finished EPDT-46887"
echo "-------------------"
