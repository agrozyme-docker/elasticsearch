FROM agrozyme/alpine:3.8
COPY source /

RUN set -euxo pipefail \
  && chmod +x /usr/local/bin/*.sh \
  && apk add --no-cache elasticsearch \
  && mkdir -p /var/lib/elasticsearch /var/log/elasticsearch /usr/share/java/elasticsearch/plugins \
  && sed -ri \
  -e 's!^[#[:space:]]*(path.data:)[[:space:]]+.*$!\1 /var/lib/elasticsearch !i' \
  -e 's!^[#[:space:]]*(path.logs:)[[:space:]]+.*$!\1 /var/log/elasticsearch !i' \
  -e 's!^[#[:space:]]*(network.host:)[[:space:]]+.*$!\1 0.0.0.0 !i' \
  /etc/elasticsearch/elasticsearch.yml

ENV ES_PATH_CONF=/etc/elasticsearch
EXPOSE 9200 9300
CMD ["agrozyme.elasticsearch.command.sh"]
