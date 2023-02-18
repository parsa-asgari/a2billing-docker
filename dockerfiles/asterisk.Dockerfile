FROM andrius/asterisk:alpine-3.3-13.17.2

COPY .docker/a2billing.conf /etc/a2billing.conf
