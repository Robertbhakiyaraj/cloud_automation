echo "----------------------------"
echo "Creating MQ binding files..."

bind_dir=/opt/epp/gateway/mqm
rm -r $bind_dir/PSH/queue
rm -r $bind_dir/PSH/qcf

rm -r $bind_dir/IPE/queue
rm -r $bind_dir/IPE/qcf

rm -r $bind_dir/queue
rm -r $bind_dir/qcf

mkdir -p $bind_dir/PSH/queue
mkdir -p $bind_dir/PSH/qcf

mkdir -p $bind_dir/IPE/queue
mkdir -p $bind_dir/IPE/qcf

mkdir -p $bind_dir/queue
mkdir -p $bind_dir/qcf

MQ_QMGR_NAME=PKSNSMQ
#mq_hostname setup as environment variable {{.Values.name}}-mqm
MQ_PORT=1414
MQ_TRANSPORT=CLIENT
MQ_CHANNEL=DEV.APP.SVRCONN



sed -i -e '$a\' /opt/epp/gateway/mqm-init/PSH/queue/jmsqueues.txt
sed -i -e '$a\' /opt/epp/gateway/mqm-init/IPE/queue/jmsqueuesForeignServer_PSH_to_IPE.txt
sed -i -e '$a\' /opt/epp/gateway/mqm-init/IPE/queue/jmsqueues.txt
sed -i -e '$a\' /opt/epp/gateway/mqm-init/IPE/queue/jmsqueuesForeignServer_IPE_to_PSH.txt
sed -i -e '$a\' /opt/epp/gateway/mqm-init/PSH/queue/jmstopics.txt
sed -i -e '$a\' /opt/epp/gateway/mqm-init/IPE/queue/jmstopics.txt

if [ "$IS_IPE_PSH" == "true" ]; then

  cat /opt/epp/gateway/mqm-init/PSH/queue/jmsqueues.txt | sort > /tmp/sorted-psh-jmsqueues.txt
  cat /opt/epp/gateway/mqm-init/IPE/queue/jmsqueuesForeignServer_PSH_to_IPE.txt | sort > /tmp/sorted-ipe-jmsqueuesForeignServer_PSH_to_IPE.txt
  cat /opt/epp/gateway/mqm-init/IPE/queue/jmsqueues.txt | sort > /tmp/sorted-ipe-jmsqueues.txt
  cat /opt/epp/gateway/mqm-init/IPE/queue/jmsqueuesForeignServer_IPE_to_PSH.txt | sort > /tmp/sorted-ipe-jmsqueuesForeignServer_IPE_to_PSH.txt

  #Do PSH rework for inter-queue mappings
  comm /tmp/sorted-psh-jmsqueues.txt /tmp/sorted-ipe-jmsqueuesForeignServer_PSH_to_IPE.txt -2 -3 > $bind_dir/PSH/queue/psh-to-psh-queues.txt

  #Do IPE rework for inter-queue mappings
  comm /tmp/sorted-ipe-jmsqueues.txt /tmp/sorted-ipe-jmsqueuesForeignServer_IPE_to_PSH.txt -2 -3 > $bind_dir/IPE/queue/ipe-to-ipe-queues.txt

  #Begin PSH queue definitions
  echo "Generating instruct.mq script for queues from PSH/queue/psh-to-psh-queues.txt"
  while IFS='' read -r line; do
    queue_name=$(echo $line|sed -E 's/:.*//g')
    q_upper=$(echo $queue_name| tr '[:lower:]' '[:upper:]')
    printf "def q(%s) qmgr(%s) queue(DEV.PSH.%s)\n" $queue_name $MQ_QMGR_NAME $q_upper  >> $bind_dir/PSH/queue/instruct.mq
  done < $bind_dir/PSH/queue/psh-to-psh-queues.txt

  echo "Generating instruct.mq script for queues from PSH/queue/jmsqueuesForeignServer_PSH_to_IPE.txt"
  while IFS='' read -r line; do
    queue_name=$(echo $line|sed -E 's/:.*//g')
    q_upper=$(echo $queue_name| tr '[:lower:]' '[:upper:]')
    printf "def q(%s) qmgr(%s) queue(DEV.IPE.%s)\n" $queue_name $MQ_QMGR_NAME $q_upper  >> $bind_dir/PSH/queue/instruct.mq
  done < /opt/epp/gateway/mqm-init/IPE/queue/jmsqueuesForeignServer_PSH_to_IPE.txt


  while IFS='' read -r line; do
    topic_name=$(echo $line|awk -F: '{print $1}')
    t_upper=$(echo $topic_name| tr '[:lower:]' '[:upper:]')
    printf "def t(%s) topic(DEV.PSH.%s)\n" $t_upper $t_upper >> $bind_dir/PSH/queue/instruct.mq
  done < /opt/epp/gateway/mqm-init/PSH/queue/jmstopics.txt

  #Begin IPE queues
  echo "Generating instruct.mq script for queues from IPE/queue/psh-to-psh-queues.txt"
  while IFS='' read -r line; do
    queue_name=$(echo $line|sed -E 's/:.*//g')
    q_upper=$(echo $queue_name| tr '[:lower:]' '[:upper:]')
    printf "def q(%s) qmgr(%s) queue(DEV.IPE.%s)\n" $queue_name $MQ_QMGR_NAME $q_upper  >> $bind_dir/IPE/queue/instruct.mq
  done < $bind_dir/IPE/queue/ipe-to-ipe-queues.txt

  echo "Generating instruct.mq script for queues from IPE/queue/jmsqueuesForeignServer_PSH_to_IPE.txt"
  while IFS='' read -r line; do
    queue_name=$(echo $line|sed -E 's/:.*//g')
    q_upper=$(echo $queue_name| tr '[:lower:]' '[:upper:]')
    printf "def q(%s) qmgr(%s) queue(DEV.PSH.%s)\n" $queue_name $MQ_QMGR_NAME $q_upper  >> $bind_dir/IPE/queue/instruct.mq
  done < /opt/epp/gateway/mqm-init/IPE/queue/jmsqueuesForeignServer_IPE_to_PSH.txt

  echo "Adding topics to instruct.mq script from IPE/queue/jmstopics.txt"
  while IFS='' read -r line; do
    topic_name=$(echo $line|awk -F: '{print $1}')
    t_upper=$(echo $topic_name| tr '[:lower:]' '[:upper:]')
    printf "def t(%s) topic(DEV.IPE.%s)\n" $t_upper $t_upper >> $bind_dir/IPE/queue/instruct.mq
  done < /opt/epp/gateway/mqm-init/IPE/queue/jmstopics.txt

  echo "Creating XA connection factory instruct.mq script for IPE..."
#if [ -z "$CREATE_FACTORY" ]; then
  printf "def xaqcf(MQXAQueueConnectionFactory) qmgr(%s) HOST(%s) PORT(%s) TRANSPORT(%s) CHANNEL(%s)\n"  $MQ_QMGR_NAME $mq_hostname $MQ_PORT $MQ_TRANSPORT $MQ_CHANNEL >> $bind_dir/IPE/qcf/instruct.mq
  printf "def xaqcf(MQQueueConnectionFactory) qmgr(%s) HOST(%s) PORT(%s) TRANSPORT(%s) CHANNEL(%s)\n"  $MQ_QMGR_NAME $mq_hostname $MQ_PORT $MQ_TRANSPORT $MQ_CHANNEL >> $bind_dir/IPE/qcf/instruct.mq
  printf "def xatcf(XAMQQCFT) qmgr(%s) HOST(%s) PORT(%s) TRANSPORT(%s) CHANNEL(%s)\n" $MQ_QMGR_NAME $mq_hostname $MQ_PORT $MQ_TRANSPORT $MQ_CHANNEL >> $bind_dir/IPE/qcf/instruct.mq
#else
#  echo "Not creating factories..."
#fi
else

  echo "Generating instruct.mq script for queues from jmsqueues.txt for PSH..."
  while IFS='' read -r line; do
    queue_name=$(echo $line|sed -E 's/:.*//g')
    q_upper=$(echo $queue_name| tr '[:lower:]' '[:upper:]')
    printf "def q(%s) qmgr(%s) queue(DEV.$EPP_APP_TYPE.%s)\n" $queue_name $MQ_QMGR_NAME $q_upper  >> $bind_dir/PSH/queue/instruct.mq
  done < /opt/epp/gateway/mqm-init/PSH/queue/jmsqueues.txt

  echo "Adding topics to instruct.mq script from jmstopics.txt for PSH..."
  while IFS='' read -r line; do
    topic_name=$(echo $line|awk -F: '{print $1}')
    t_upper=$(echo $topic_name| tr '[:lower:]' '[:upper:]')
    printf "def t(%s) topic(DEV.$EPP_APP_TYPE.%s)\n" $t_upper $t_upper >> $bind_dir/PSH/queue/instruct.mq
  done < /opt/epp/gateway/mqm-init/PSH/queue/jmstopics.txt

fi

echo "Creating XA connection factory instruct.mq script for PSH..."
#if [ -z "$CREATE_FACTORY" ]; then
  printf "def xaqcf(MQXAQueueConnectionFactory) qmgr(%s) HOST(%s) PORT(%s) TRANSPORT(%s) CHANNEL(%s)\n"  $MQ_QMGR_NAME $mq_hostname $MQ_PORT $MQ_TRANSPORT $MQ_CHANNEL >> $bind_dir/PSH/qcf/instruct.mq
  printf "def xaqcf(MQQueueConnectionFactory) qmgr(%s) HOST(%s) PORT(%s) TRANSPORT(%s) CHANNEL(%s)\n"  $MQ_QMGR_NAME $mq_hostname $MQ_PORT $MQ_TRANSPORT $MQ_CHANNEL >> $bind_dir/PSH/qcf/instruct.mq
  printf "def xatcf(XAMQQCFT) qmgr(%s) HOST(%s) PORT(%s) TRANSPORT(%s) CHANNEL(%s)\n" $MQ_QMGR_NAME $mq_hostname $MQ_PORT $MQ_TRANSPORT $MQ_CHANNEL >> $bind_dir/PSH/qcf/instruct.mq
#else
#  echo "Not creating factories..."
#fi



cd $bind_dir/PSH/queue/

echo "Making the runmqsc 20-jmsqueues.mqsc init script for the container..."
echo "
DEFINE CHANNEL(DEV.APP.SVRCONN) CHLTYPE(SVRCONN)
START CHANNEL(DEV.APP.SVRCONN)
ALTER QMGR CHLAUTH(DISABLED)
" > $bind_dir/20-jmsqueues.mqsc
cat  /opt/epp/gateway/mqm-init/PSH/queue/jmsqueues.txt | grep -oP "^[^:]*" | sort | uniq | sed -r "s/^/define qlocal(DEV.PSH./" | sed -r "s/$/) MAXDEPTH(30000)/" >> $bind_dir/20-jmsqueues.mqsc
cat  /opt/epp/gateway/mqm-init/PSH/queue/jmstopics.txt | grep ":" | tr '[:lower:]' '[:upper:]' | grep -oP "^[^:]*" | sort | uniq |  sed -r "s/^(.*)$/define topic(DEV.PSH.\1) TOPICSTR(DEV.\1)/" >> $bind_dir/20-jmsqueues.mqsc


if [ "$IS_IPE_PSH" == "true" ]; then
  cd $bind_dir/IPE/queue/

  cat  /opt/epp/gateway/mqm-init/IPE/queue/jmsqueues.txt | grep -oP "^[^:]*" | sort | uniq | sed -r "s/^/define qlocal(DEV.IPE./" | sed -r "s/$/) MAXDEPTH(30000)/" >> $bind_dir/20-jmsqueues.mqsc
  cat  /opt/epp/gateway/mqm-init/IPE/queue/jmstopics.txt | grep ":" | tr '[:lower:]' '[:upper:]' | grep -oP "^[^:]*" | sort | uniq |  sed -r "s/^(.*)$/define topic(DEV.IPE.\1) TOPICSTR(DEV.\1)/" >> $bind_dir/20-jmsqueues.mqsc
fi


build_bindings() {

PSH_OR_IPE=$1

cd $bind_dir/$PSH_OR_IPE/queue
echo "Making jndi context for where to put bindings, then create the bindings for queues..."
echo "
INITIAL_CONTEXT_FACTORY=com.sun.jndi.fscontext.RefFSContextFactory
PROVIDER_URL=file://$bind_dir/$PSH_OR_IPE/queue/
SECURITY_AUTHENTICATION=none
" > jndi.properties
ENDING=$(cat instruct.mq | grep -P 'END$')
if [[ "$ENDING" != "END" ]] ; then
  printf "END\n" >> instruct.mq
fi

echo "Making the bindings file for queues..."
export CLASSPATH="$CLASSPATH"
/opt/mqm/java/bin/JMSAdmin -v -cfg jndi.properties < instruct.mq

echo "Making jndi context for where to put bindings, then create the bindings for topics..."
cd $bind_dir/$PSH_OR_IPE/qcf/
echo "
INITIAL_CONTEXT_FACTORY=com.sun.jndi.fscontext.RefFSContextFactory
PROVIDER_URL=file://$bind_dir/$PSH_OR_IPE/qcf/
SECURITY_AUTHENTICATION=none
" > jndi.properties

ENDING=$(cat instruct.mq | grep -P 'END$')
if [[ "$ENDING" != "END" ]] ; then
  printf "END\n" >> instruct.mq
fi

echo "Making the bindings file for QCF..."
export CLASSPATH="$CLASSPATH"
/opt/mqm/java/bin/JMSAdmin -v -cfg jndi.properties < instruct.mq

}

build_bindings "PSH"

if [ "$IS_IPE_PSH" == "true" ]; then
  build_bindings "IPE"
fi

find $bind_dir/

echo
echo 'Finished creating mq bindings'
echo '-----------------------------'