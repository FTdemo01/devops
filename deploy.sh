#!/bin/bash
if ${DEPLOY_3RD:-false};then
  DEPLOY_LIST="${DEPLOY_LIST} docker-compose-stack-3rd.yml"
fi
if ${DEPLOY_DYP:-false};then
  DEPLOY_LIST="${DEPLOY_LIST} docker-compose-stack-dyp.yml"


  if ${DEPLOY_3RD:-false};then
    python tools/drop_mongo_database.py -uri $SPRING_DATA_MONGODB_URI -db mapsdb
    curl -X DELETE "$SPRING_ELASTICSEARCH_REST_URIS/audit_events*,lookup*,openslot,payer,place,price,provider,schedule,substantiatedallegation,supportedlanguage,supportedspecialneed,user?ignore_unavailable=true"
    python tools/drop_postgres_schemas.py -host reporting.dyp.cloud -db $ENVIRONMENT -w yj7fJZZqe567
  else
    curl -X DELETE "$SPRING_ELASTICSEARCH_REST_URIS/audit_events*"
  fi

  docker container prune -f
  docker image prune -f