FROM ubuntu:14.04.5

# Asterisk 11
RUN apt-get update
RUN apt-get install asterisk -y 
COPY ./.docker/asterisk-manager.conf /etc/asterisk/manager.conf
COPY ./.docker/asterisk-extensions.conf /etc/asterisk/extensions.conf

EXPOSE 5060
CMD [ "asterisk" ,"-fp" ]