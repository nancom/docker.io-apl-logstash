FROM nancom/apl-jdk8
MAINTAINER Nancom, https://github.com/nancom/docker-alpine

# Set environment variables
ENV LOGSTASH_NAME logstash
ENV LOGSTASH_VERSION 5.3.2
ENV LOGSTASH_CONFIG /opt/elk/$LOGSTASH_NAME-$LOGSTASH_VERSION/etc/logstash.json

COPY logstash-5.3.2.tar.gz /tmp
RUN apk update \
    && apk add bash tzdata openssl \
    && mkdir -p /opt/elk \
    && tar xzf /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz -C /opt/elk \
    && ln -s /opt/elk/$LOGSTASH_NAME-$LOGSTASH_VERSION /opt/elk/$LOGSTASH_NAME \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* \
    && mkdir -p /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    chmod -R 755 /scripts

# Add logstash config file
ADD etc /opt/elk/$LOGSTASH_NAME-$LOGSTASH_VERSION/etc
ADD scripts /scripts

# Expose Syslog TCP and UDP ports
EXPOSE 514 514/udp 8080 5044 9600
WORKDIR /opt/elk/$LOGSTASH_NAME

ENTRYPOINT ["/scripts/run.sh"]
