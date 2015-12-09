###############################################
# Ubuntu with added Teamspeak 3 Server. 
# Uses SQLite Database on default.
###############################################

# Using latest Ubuntu image as base
FROM ubuntu:14.04
MAINTAINER Pit Kleyersburg <pitkley@googlemail.com>

## Set some variables for override.
# Download Link of TS3 Server
ENV TEAMSPEAK_VERSION 3.0.11.4
ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/${TEAMSPEAK_VERSION}/teamspeak3-server_linux-amd64-${TEAMSPEAK_VERSION}.tar.gz

# Create volume-directory
RUN mkdir /teamspeak3

# Download TS3 file and extract it into /opt.
ADD ${TEAMSPEAK_URL} /opt/
RUN cd /opt && tar -xzf /opt/teamspeak3-server_linux-amd64-${TEAMSPEAK_VERSION}.tar.gz

ADD /scripts/ /opt/scripts/

# Add new user and chown on mapped folders
RUN adduser --disabled-password --gecos "" teamspeak

RUN chown -R teamspeak:teamspeak /opt/teamspeak3-server_linux-amd64/
RUN chown -R teamspeak:teamspeak /opt/scripts/
RUN chown -R teamspeak:teamspeak /teamspeak3

RUN chmod -R 774 /opt/scripts/

# Inject a Volume for any TS3-Data that needs to be persisted or to be accessible from the host. (e.g. for Backups)
VOLUME ["/teamspeak3"]

# switch user
USER teamspeak

ENTRYPOINT ["/opt/scripts/docker-ts3.sh"]

# Expose the Standard TS3 port.
EXPOSE 9987/udp
# for files
EXPOSE 30033 
# for ServerQuery
EXPOSE 10011
