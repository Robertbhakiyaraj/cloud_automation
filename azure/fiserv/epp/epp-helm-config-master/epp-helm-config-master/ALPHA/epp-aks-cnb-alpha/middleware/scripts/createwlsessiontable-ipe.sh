echo "------------------------------------------------"
echo "EPDT-46819 Creating WL_SERVLET_SESSIONS table..."
echo
cd ${TENANT_HOME}/init-config/sql

cat > wlservletsessions.sql <<'EOF'
create table wl_servlet_sessions
  ( wl_id VARCHAR2(100) NOT NULL,
    wl_context_path VARCHAR2(100) NOT NULL,
    wl_is_new CHAR(1),
    wl_create_time NUMBER(20),
    wl_is_valid CHAR(1),
    wl_session_values LONG RAW,
    wl_access_time NUMBER(20),
    wl_max_inactive_interval INTEGER,
   PRIMARY KEY (wl_id, wl_context_path) );

EOF

sqlplus ${Q5DataSourceIpeUser}/${Q5DataSourceIpePassword}@${Q5DataSourceURL#*@} @wlservletsessions.sql

echo
echo "Finished creating WL_SERVLET_SESSIONS table"
echo "-------------------------------------------"
echo