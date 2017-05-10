FROM oraclelinux:7-slim

ENV ORACLE_HOME=/opt/oracle/product/12.1.0.2/dbhome_1 \
    ORACLE_BASE=/opt/oracle

ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib \
    PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:/usr/sbin:$PATH \
    INSTALL_DIR=$ORACLE_BASE/install \
    CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

ADD *.zip /tmp/
RUN yum install -y oracle-rdbms-server-12cR1-preinstall unzip wget tar openssl 
RUN mkdir /opt/oracle && \
    unzip /tmp/oracledatabaseclient-linux.x64-12.1.0.2.0.zip -d /tmp && \
    rm -f /tmp/oracledatabaseclient-linux.x64-12.1.0.2.0.zip
RUN mkdir -p $ORACLE_HOME $ORACLE_BASE/oradata && \
    chown -R oracle:dba /opt/oracle
ADD client_install.rsp /tmp 
USER oracle
RUN /tmp/client/runInstaller -silent -waitforcompletion -responseFile /tmp/client_install.rsp -ignoresysprereqs -ignoreprereq
USER root
RUN /opt/oracle/oraInventory/orainstRoot.sh
