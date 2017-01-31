#!/bin/bash
ADMIN_USER=${ADMIN_USER:-admin}
ADMIN_PASS=${ADMIN_PASS:-tomcat}
MAX_UPLOAD_SIZE=${MAX_UPLOAD_SIZE:-52428800}
#CATALINA_OPTS=${CATALINA_OPTS:-"-Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m -Djava.security.egd=file:/dev/./urandom"}

#export CATALINA_OPTS="${CATALINA_OPTS}"

#Example configuration file
CONF=/opt/apache-tomcat/webapps/ROOT/WEB-INF/classes/META-INF/persistence.xml

cat << EOF > /opt/apache-tomcat/conf/tomcat-users.xml
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users>
<user username="${ADMIN_USER}" password="${ADMIN_PASS}" roles="admin-gui,manager-gui"/>
</tomcat-users>
EOF

if [ -f "/opt/apache-tomcat/webapps/manager/WEB-INF/web.xml" ]
then
	sed -i "s#.*max-file-size.*#\t<max-file-size>${MAX_UPLOAD_SIZE}</max-file-size>#g" /opt/apache-tomcat/webapps/manager/WEB-INF/web.xml
	sed -i "s#.*max-request-size.*#\t<max-request-size>${MAX_UPLOAD_SIZE}</max-request-size>#g" /opt/apache-tomcat/webapps/manager/WEB-INF/web.xml
fi


if [ -z ${MYSQL_USER} ]
then
  MYSQL_USER=user
fi
if [ -z ${MYSQL_PASSWORD} ]
then
  MYSQL_PASSWORD=pass
fi
if [ -z ${MYSQL_DATABASE} ]
then
  MYSQL_DATABASE=mdm
fi
if [ -z ${DATABASE_SERVICE_HOST} ]
then
  DATABASE_SERVICE_HOST=localhost
fi
if [ -z ${DATABASE_SERVICE_PORT_MARIADB}]
then
  DATABASE_SERVICE_PORT_MARIADB=3306
fi


sed -i "s/CHANGE_USER/${MYSQL_USER}/g" ${CONF}
sed -i "s/CHANGE_PASSWORD/${MYSQL_PASSWORD}/g" ${CONF}
sed -i "s/CHANGE_SERVICE_HOST/${DATABASE_SERVICE_HOST}/g" ${CONF}
sed -i "s/CHANGE_SERVICE_PORT/${THBOX_SERVICE_PORT_MARIADB}/g" ${CONF}
sed -i "s/CHANGE_DATABASE/${MYSQL_DATABASE}/g" ${CONF}

exec /opt/apache-tomcat/bin/catalina.sh run
