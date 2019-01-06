FROM agrozyme/openjdk:8
COPY source /

RUN set -euo pipefail \
  && chmod +x /usr/local/bin/*.sh \
  && apk add --no-cache coreutils \
  && wget -q -O /tmp/elasticsearch.rpm https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.4.rpm \
  && rpm --install --nodeps /tmp/elasticsearch.rpm \
  && rm -rf /tmp/elasticsearch.rpm /usr/share/elasticsearch/modules/x-pack-ml \
  && chown -R root:root /etc/elasticsearch /etc/sysconfig/elasticsearch \
  && chmod -R +r /etc/elasticsearch /etc/sysconfig/elasticsearch \
  && chmod -s /etc/elasticsearch \
  && chmod +x /etc/elasticsearch \
  && sed -ri \
  -e 's!^[#[:space:]]*(path.data:)[[:space:]]+.*$!\1 /var/lib/elasticsearch !i' \
  -e 's!^[#[:space:]]*(path.logs:)[[:space:]]+.*$!\1 /var/log/elasticsearch !i' \
  -e 's!^[#[:space:]]*(network.host:)[[:space:]]+.*$!\1 0.0.0.0 !i' \
  -e '$ a xpack.ml.enabled: false' \
  /etc/elasticsearch/elasticsearch.yml

ENV ES_PATH_CONF=/etc/elasticsearch
EXPOSE 9200 9300
CMD ["agrozyme.elasticsearch.command.sh"]
