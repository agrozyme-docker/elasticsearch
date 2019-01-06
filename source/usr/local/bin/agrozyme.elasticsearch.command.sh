#!/bin/bash
set -euo pipefail

function main() {
  agrozyme.alpine.function.sh change_core
  chown -R core:core /var/lib/elasticsearch /var/log/elasticsearch
  exec su-exec core /usr/share/elasticsearch/bin/elasticsearch
}

main "$@"
