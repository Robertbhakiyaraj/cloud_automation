#!/bin/bash
echo "------------------------------------------------------------------------------------"
echo "INFO:  Inserting parameters into IpHoppingPreventionFilter in web.xml files..."
case $WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP in
    'Yes'|'No')
        echo "INFO:  WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP valid value: '$WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP'"
    ;;
    '')
        echo "INFO:  WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP empty."
        echo "INFO:  Setting WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP to default value 'No'."
        WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP=No
    ;;
    *)
        echo "WARN:  WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP not valid value.."
        echo "INFO:  Setting WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP to default value 'No'."
        WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP=No
    ;;
esac

if [[ ! -v WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKHEADERS ]]
then
    echo "INFO:  WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKHEADERS variable not set."
    echo "INFO:  Setting WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKHEADERS to default value 'Host,User-Agent,Accept-Charset'."
    WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKHEADERS=User-Agent,Accept-Charset
else
    echo "INFO:  Setting WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKHEADERS has value '$WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKHEADERS'."
fi


cd $TENANT_HOME
pshwebappwar=$(ls ${DPSAPP_EAR}psh-webapp-*.war/WEB-INF/web.xml)
echo "DEBUG: pshwebappwar: $pshwebappwar"
jmxwebappwar=$(ls ${DPSAPP_EAR}JMXWebAppWar-*.war/WEB-INF/web.xml)
echo "DEBUG: jmxwebappwar: $jmxwebappwar"

for webxml in $pshwebappwar $jmxwebappwar
do
    echo "INFO:  Updating file $webxml to alter IpHoppingPreventionFilter"
    xmllint --shell $webxml <<XOF
setrootns
cd (/defaultns:web-app)
cd //defaultns:filter[defaultns:filter-name="IpHoppingPreventionFilter"]
cd defaultns:init-param[defaultns:param-name='checkClientIp']
cd defaultns:param-value
set $WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKCLIENTIP
cat
cd ..
cd ..
cd defaultns:init-param[defaultns:param-name='checkHeaders']
cd defaultns:param-value
set $WEB_XML_IPHOPPINGPREVENTIONFILTER_CHECKHEADERS
cat
save
XOF
done
echo "INFO:  Finished inserting parameters into IpHoppingPreventionFilter in web.xml files"
echo "------------------------------------------------------------------------------------"
echo
echo