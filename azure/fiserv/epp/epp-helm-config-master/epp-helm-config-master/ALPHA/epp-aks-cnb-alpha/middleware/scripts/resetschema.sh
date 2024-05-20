echo "----------------------------"
echo "Resetting database schema..."

cd ${TENANT_HOME}/init-config/sql

cat > resetschema.sql <<'EOF'
select 'drop '||object_type||' '||object_name||
       decode(object_type,'CLUSTER',' including tables cascade constraints',
                          'OPERATOR', ' force',
                          'TABLE',' cascade constraints',
                          'TYPE', ' force',
                          'VIEW',' cascade constraints',
                          '')||';'
from user_objects
where object_type in ('CLUSTER', 'CONTEXT', 'DATABASE LINK', 'DIMENSION',
                      'DIRECTORY', 'FUNCTION', 'INDEX TYPE', 'JAVA',
                      'LIBRARY', 'MATERIALIZED VIEW', 'OPERATOR',
                      'OUTLINE', 'PACKAGE', 'PROCEDURE', 'SEQUENCE',
                      'SYNONYM', 'TABLE', 'TYPE', 'VIEW')
order by object_type, object_name
/
spool my.sql
/
spool off
@my

EOF

sqlplus ${Q5DataSourceUser}/${Q5DataSourcePassword}@${Q5DataSourceURL#*@} @resetschema.sql

echo
echo "Finished resetting database schema"
echo "----------------------------------"
echo
