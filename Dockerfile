###############################################
# Ubuntu with added Teamspeak 3 Server. 
# Uses SQLite Database on default.
###############################################

# Using latest Ubuntu image as base
FROM ubuntu

MAINTAINER Alex

## ENV Variables. Can be overriden at "docker run" with -e
# Download Link of TS3 Server
ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.11.1/teamspeak3-server_linux-amd64-3.0.11.1.tar.gz

# Inject a Volume for any TS3-Data that needs to be persisted or to be accessible from the host. (e.g. for Backups)
VOLUME ["/teamspeak3"]

# Create a user (teamspeak) for the Server.
RUN useradd -d /home/teamspeak -m teamspeak

# Download TS3 file and extract it into ~teamspeak. 
ADD ${TEAMSPEAK_URL} /home/teamspeak/
RUN cd /home/teamspeak && tar -xzf /home/teamspeak/teamspeak3-server*.tar.gz

# Copy and chmod scripts.
ADD /scripts/ /home/teamspeak/scripts/
RUN chmod -R 774 /home/teamspeak/scripts/

# Change user for the entrypoint.
USER teamspeak

# docker-ts3.sh will symlink conf-files and start the server
ENTRYPOINT ["/home/teamspeak/scripts/docker-ts3.sh"]

# Expose the Standard TS3 port.
EXPOSE 9987/udp
# for files
EXPOSE 30033 
# for ServerQuery
EXPOSE 10011
