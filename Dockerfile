# Java Version
ARG JAVA_VERSION=19-jdk

###########################
### Running environment ###
###########################
FROM openjdk:${JAVA_VERSION}-alpine3.16 AS runtime

##########################
### Environment & ARGS ###
##########################
ENV MINECRAFT_PATH=/opt/minecraft
ENV SERVER_PATH=${MINECRAFT_PATH}/server
ENV DATA_PATH=${MINECRAFT_PATH}/data
ENV LOGS_PATH=${MINECRAFT_PATH}/logs
ENV CONFIG_PATH=${MINECRAFT_PATH}/config
ENV WORLDS_PATH=${MINECRAFT_PATH}/worlds
ENV PLUGINS_PATH=${MINECRAFT_PATH}/plugins
ENV PROPERTIES_LOCATION=${CONFIG_PATH}/server.properties
ENV JAVA_HEAP_SIZE=2G
ENV JAVA_ARGS="-server -Dcom.mojang.eula.agree=true"
ENV SPIGOT_ARGS="--nojline"
ENV PAPER_ARGS=""

#################
### Libraries ###
#################
ADD https://bootstrap.pypa.io/get-pip.py .
RUN apk update
RUN apk add python3 gettext curl bash
RUN python3 get-pip.py

RUN pip install mcstatus

###################
### Healthcheck ###
###################

ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_DATABASE

HEALTHCHECK --interval=60s --timeout=20s --start-period=300s \
    CMD mcstatus localhost:$( cat $PROPERTIES_LOCATION | grep "server-port" | cut -d'=' -f2 ) ping

#########################
### Working directory ###
#########################
WORKDIR ${SERVER_PATH}

###########################################
### Obtain runable jar from build stage ###
###########################################

RUN curl -Lo paper.jar https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/493/downloads/paper-1.20.4-493.jar 
RUN mv paper.jar ${SERVER_PATH}/

######################
### Obtain scripts ###
######################
ADD scripts/docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

############
### User ###
############
RUN adduser -s /bin/bash minecraft -g minecraft -h ${MINECRAFT_PATH} -D && \
    mkdir ${LOGS_PATH} ${DATA_PATH} ${WORLDS_PATH} ${PLUGINS_PATH} ${CONFIG_PATH} && \
    chown -R minecraft:minecraft ${MINECRAFT_PATH}

USER minecraft

#########################
### Setup environment ###
#########################
# Create symlink for plugin volume as hotfix for some plugins who hard code their directories
RUN ln -s $PLUGINS_PATH $SERVER_PATH/plugins && \
    # Create symlink for persistent data
    ln -s $DATA_PATH/banned-ips.json $SERVER_PATH/banned-ips.json && \
    ln -s $DATA_PATH/banned-players.json $SERVER_PATH/banned-players.json && \
    ln -s $DATA_PATH/help.yml $SERVER_PATH/help.yml && \
    ln -s $DATA_PATH/ops.json $SERVER_PATH/ops.json && \
    ln -s $DATA_PATH/permissions.yml $SERVER_PATH/permissions.yml && \
    ln -s $DATA_PATH/whitelist.json $SERVER_PATH/whitelist.json && \
    # Create symlink for logs
    ln -s $LOGS_PATH $SERVER_PATH/logs



RUN ls

ENTRYPOINT ["./docker-entrypoint.sh" ]

# Run Command
CMD [ "serve" ]
