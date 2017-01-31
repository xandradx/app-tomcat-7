FROM openjdk:latest
MAINTAINER Jorge Andrade <jandrade@i-t-m.com>
ENV TOMCAT_VERSION 7.0.75
ENV APP_VERSION 1.0
ADD apache-tomcat-${TOMCAT_VERSION}* /opt/
EXPOSE 8080
ADD run.sh /usr/local/bin/
RUN mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/apache-tomcat ; \
    rm -Rf /opt/apache-tomcat/webapps/ROOT* ; \
    rm -rf /opt/apache-tomcat/webapps/docs /opt/apache-tomcat/webapps/examples /opt/apache-tomcat/webapps/ROOT
ADD app /opt/apache-tomcat/webapps/ROOT
RUN chmod 755 /usr/local/bin/run.sh ; \
    chgrp -R 0 /opt/apache-tomcat ; \
    chmod -R g+rw /opt/apache-tomcat ; \
    find /opt/apache-tomcat -type d -exec chmod g+x {} \;
CMD ["/usr/local/bin/run.sh"]
